"""Run each custom Falstad circuit on a local CircuitJS build and check what it must show.
Needs: CircuitJS built from github.com/pfalstad/circuitjs1 (gradle makeSite) and served with
  python3 -m http.server 8765 --bind 127.0.0.1   (inside its site/ folder), node + Playwright.
Usage: python3 -I check.py [id ...]     Recordings and screenshots go to build/falstad-test/."""
import json, math, os, re, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
URLS = json.load(open(os.path.join(ROOT, 'build/falstad-custom/urls.json')))
OUT = os.path.join(ROOT, 'build/falstad-test')
os.makedirs(OUT, exist_ok=True)
LOCAL = 'http://127.0.0.1:8765/'


def run(cid, tsim, probes):
    """probes: list of (name, kind). Returns (meta, t, {name/kind: values})."""
    names = URLS[cid]['names']
    spec = ','.join(f'{names[n]}:{k}' for n, k in probes)
    url = URLS[cid]['url'].replace('https://www.falstad.com/circuit/', LOCAL)
    out = os.path.join(OUT, cid + '.json')
    r = subprocess.run(['node', os.path.join(HERE, 'run.js'), url, str(tsim), out, spec], capture_output=True, text=True, timeout=900)
    d = json.load(open(out))
    vals = {f'{n}/{k}': d['rec']['v'][j] for j, (n, k) in enumerate(probes)}
    return d, d['rec']['t'], vals


def window(t, v, t0, t1):
    return [x for tt, x in zip(t, v) if t0 <= tt <= t1]


def rms(v):
    return math.sqrt(sum(x * x for x in v) / len(v)) if v else 0


def mean(v):
    return sum(v) / len(v) if v else 0


def resample(t, v, t0, t1, n):
    """uniform resample by nearest previous sample"""
    out, j = [], 0
    for k in range(n):
        tt = t0 + (t1 - t0) * k / n
        while j + 1 < len(t) and t[j + 1] <= tt:
            j += 1
        out.append(v[j])
    return out


def amp_at(t, v, t0, t1, f):
    """amplitude of the component at frequency f (single-bin DFT over [t0,t1])"""
    n = 4096
    x = resample(t, v, t0, t1, n)
    dt = (t1 - t0) / n
    re_ = sum(x[k] * math.cos(2 * math.pi * f * k * dt) for k in range(n))
    im_ = sum(x[k] * math.sin(2 * math.pi * f * k * dt) for k in range(n))
    return 2 * math.hypot(re_, im_) / n


def db(a, b):
    return 20 * math.log10(a / b) if a > 0 and b > 0 else float('-inf')


def base_report(cid, d):
    ok = d['running'] and not d['errors'] and d['meta']['n'] == URLS[cid]['nlines']
    print(f"[{cid}] elements {d['meta']['n']}/{URLS[cid]['nlines']}  running={d['running']}  t={d['simT']:.4f}s  wall={d['wall']:.0f}s  errors={d['errors'][:1]}")
    return ok


CHECKS = {}


def check(fn):
    CHECKS[fn.__name__.replace('_', '-')] = fn
    return fn


@check
def tanque_paralelo():
    cid = 'tanque-paralelo'
    d, t, v = run(cid, 1.05, [('C', 'v'), ('gen', 'info')])
    ok = base_report(cid, d)
    vc, info = v['C/v'], v['gen/info']
    k = max(range(len(vc)), key=lambda j: abs(vc[j]))
    f = re.search(r'f = ([\d.]+ k?Hz)', info[k]).group(1)
    # amplitude far from f0
    lo = [abs(x) for x, s in zip(vc, info) if re.search(r'f = (2[5-9]\d|3[0-4]\d)\.\d+ Hz', s)]
    print(f'   peak |V_C| = {abs(vc[k]):.3f} V at f = {f}; max |V_C| near 250-350 Hz = {max(lo):.3f} V')
    return ok and abs(vc[k]) > 4.0 and ('kHz' in f and 0.9 < float(f.split()[0]) < 1.1) and max(lo) < 1.5


def match_net(cid, label):
    d, t, v = run(cid, 0.02, [('RL1', 'v'), ('RL2', 'v')])
    ok = base_report(cid, d)
    a1 = rms(window(t, v['RL1/v'], 0.01, 0.02)) * math.sqrt(2)
    a2 = rms(window(t, v['RL2/v'], 0.01, 0.02)) * math.sqrt(2)
    p1, p2 = (a1 / math.sqrt(2)) ** 2 / 200, (a2 / math.sqrt(2)) ** 2 / 200
    print(f'   {label}: load peak {a1:.2f} V ({p1:.3f} W); direct: {a2:.2f} V ({p2:.3f} W)')
    return ok and abs(a1 - 10) < 0.5 and abs(a2 - 8) < 0.2 and abs(p1 - 0.25) < 0.02


@check
def red_L():
    return match_net('red-L', 'red L')


@check
def red_T():
    return match_net('red-T', 'red T')


@check
def red_pi():
    cid = 'red-pi'
    d, t, v = run(cid, 0.03, [('PA', 'v'), ('RL', 'v')])
    ok = base_report(cid, d)
    t0, t1 = 0.01, 0.03
    pa1, pa3 = amp_at(t, v['PA/v'], t0, t1, 1000), amp_at(t, v['PA/v'], t0, t1, 3000)
    rl1, rl3, rl5 = (amp_at(t, v['RL/v'], t0, t1, f) for f in (1000, 3000, 5000))
    print(f'   PA: H1 {pa1:.2f} V, H3 {pa3:.2f} V ({db(pa3, pa1):.1f} dB)')
    print(f'   load: H1 {rl1:.2f} V, H3 {rl3:.4f} V ({db(rl3, rl1):.1f} dB), H5 {db(rl5, rl1):.1f} dB')
    return ok and db(rl3, rl1) < -30


def ripple(t, v, t0, t1):
    w = window(t, v, t0, t1)
    return mean(w), max(w) - min(w)


@check
def filtro_pi_fuente():
    cid = 'filtro-pi-fuente'
    d, t, v = run(cid, 3.0, [('RLA', 'v'), ('RLB', 'v'), ('C1', 'v'), ('C2', 'v')])
    ok = base_report(cid, d)
    res = {}
    for n in ('RLA', 'RLB', 'C1', 'C2'):
        m, r = ripple(t, v[n + '/v'], d['simT'] - 0.2, d['simT'])
        res[n] = (m, r)
        print(f'   {n}: mean {m:.2f} V, ripple p-p {r:.3f} V')
    return ok and res['RLA'][1] > 1.5 and res['RLB'][1] < 0.3 * res['RLA'][1]


@check
def fuente_completa():
    cid = 'fuente-completa'
    d, t, v = run(cid, 1.0, [('Psec', 'v'), ('Cf', 'v'), ('RL', 'v')])
    ok = base_report(cid, d)
    T = d['simT']
    sec = rms(window(t, v['Psec/v'], T - 0.2, T))
    mc, rc = ripple(t, v['Cf/v'], T - 0.2, T)
    mo, ro = ripple(t, v['RL/v'], T - 0.2, T)
    print(f'   secondary {sec:.2f} V rms; capacitor mean {mc:.2f} V ripple {rc:.2f} V; output mean {mo:.2f} V ripple {ro*1000:.1f} mV; load current {mo/27.6:.3f} A')
    return ok and 13.0 < mo < 14.6 and ro < 0.3 * rc


@check
def clase_c():
    cid = 'clase-c'
    d, t, v = run(cid, 0.06, [('Vin', 'v'), ('Q', 'info'), ('RL', 'v')])
    ok = base_report(cid, d)
    T = d['simT']
    ics = []
    for tt, s in zip(t, v['Q/info']):
        if tt < T - 0.01:
            continue
        m = re.search(r'Ic = (-?[\d.]+) (µA|mA|A|nA|pA)', s)
        if m:
            val = float(m.group(1)) * {'pA': 1e-12, 'nA': 1e-9, 'µA': 1e-6, 'mA': 1e-3, 'A': 1}[m.group(2)]
            ics.append(val)
    conduct = sum(1 for x in ics if x > 1e-3) / max(1, len(ics))
    rl1 = amp_at(t, v['RL/v'], T - 0.02, T, 1000)
    rl2, rl3 = amp_at(t, v['RL/v'], T - 0.02, T, 2000), amp_at(t, v['RL/v'], T - 0.02, T, 3000)
    print(f'   Ic > 1 mA during {conduct*100:.0f} % of the cycle; Ic max {max(ics)*1000:.1f} mA')
    print(f'   tank: H1 {rl1:.2f} V, H2 {db(rl2, rl1):.1f} dB, H3 {db(rl3, rl1):.1f} dB')
    return ok and conduct < 0.4 and rl1 > 1 and db(rl2, rl1) < -20 and db(rl3, rl1) < -20


@check
def base_comun():
    cid = 'base-comun'
    d, t, v = run(cid, 0.3, [('Vin', 'v'), ('RL', 'v'), ('Re', 'v')])
    ok = base_report(cid, d)
    T = d['simT']
    vi = resample(t, v['Vin/v'], T - 0.01, T, 2000)
    vo = resample(t, v['RL/v'], T - 0.01, T, 2000)
    mo = mean(vo)
    vo = [x - mo for x in vo]
    corr = sum(a * b for a, b in zip(vi, vo)) / math.sqrt(sum(a * a for a in vi) * sum(b * b for b in vo))
    ai, ao = rms(vi) * math.sqrt(2), rms(vo) * math.sqrt(2)
    ie = mean(window(t, v['Re/v'], T - 0.01, T)) / 1500
    print(f'   in {ai*1000:.1f} mV peak, out {ao:.3f} V peak, gain {ao/ai:.1f}, correlation in/out {corr:+.3f}, I_E {ie*1000:.2f} mA')
    return ok and corr > 0.95 and 20 < ao / ai < 80


@check
def clases_ab():
    cid = 'clases-ab'
    d, t, v = run(cid, 0.02, [('VinB', 'v'), ('RLB', 'v'), ('RLAB', 'v')])
    ok = base_report(cid, d)
    T = d['simT']
    # dead zone: output while |vin| < 0.4 V
    dz = [abs(o) for i, o, tt in zip(v['VinB/v'], v['RLB/v'], t) if tt > T - 0.005 and abs(i) < 0.4]
    res = {}
    for n in ('RLB', 'RLAB'):
        h1 = amp_at(t, v[n + '/v'], T - 0.01, T, 1000)
        h3 = amp_at(t, v[n + '/v'], T - 0.01, T, 3000)
        res[n] = db(h3, h1)
        print(f'   {n}: H1 {h1:.2f} V, H3 {res[n]:.1f} dB')
    print(f'   class B output while |vin| < 0.4 V: max {max(dz):.3f} V')
    return ok and max(dz) < 0.1 and res['RLAB'] < res['RLB'] - 10


@check
def modulacion_am():
    cid = 'modulacion-am'
    d, t, v = run(cid, 0.06, [('R', 'v')])
    ok = base_report(cid, d)
    T = d['simT']
    a = {f: amp_at(t, v['R/v'], T - 0.05, T, f) for f in (1600, 1800, 2000, 2200, 2400)}
    print('   ' + ', '.join(f'{f} Hz {x:.2f} V' for f, x in a.items()))
    return ok and a[1800] > 0.3 * a[2000] and a[2200] > 0.3 * a[2000] and a[1600] < 0.1 * a[2000]


@check
def modulacion_fm():
    cid = 'modulacion-fm'
    d, t, v = run(cid, 0.06, [('R1', 'v'), ('R2', 'v')])
    ok = base_report(cid, d)
    T = d['simT']
    res = {}
    for n in ('R1', 'R2'):
        a = [amp_at(t, v[n + '/v'], T - 0.05, T, 2000 + 200 * k) for k in range(0, 6)]
        res[n] = a
        print(f'   {n}: carrier and upper bands (V): ' + ', '.join(f'{x:.2f}' for x in a))
    # β=0.5: J0=0.94, J1=0.24, J2=0.03 ; β=3: J0=-0.26, J1=0.34, J2=0.49, J3=0.31, J4=0.13
    b1 = res['R1']
    b3 = res['R2']
    return ok and b1[1] / b1[0] > 0.15 and b1[2] / b1[0] < 0.1 and b3[2] > b3[0] and b3[3] > 0.2 * 5


@check
def mezclador():
    cid = 'mezclador'
    d, t, v = run(cid, 0.06, [('P', 'v'), ('RL', 'v'), ('X', 'v')])
    ok = base_report(cid, d)
    T = d['simT']
    for n in ('X/v', 'RL/v'):
        a = {f: amp_at(t, v[n], T - 0.04, T, f) for f in (500, 1000, 1500, 2500)}
        print(f'   {n}: ' + ', '.join(f'{f} Hz {x:.2f} V' for f, x in a.items()))
    a = {f: amp_at(t, v['RL/v'], T - 0.04, T, f) for f in (500, 2500)}
    return ok and a[2500] < 0.15 * a[500]


if __name__ == '__main__':
    ids = sys.argv[1:] or list(CHECKS)
    for cid in ids:
        try:
            print(f'   => {"PASS" if CHECKS[cid]() else "FAIL"}')
        except Exception as e:
            print(f'[{cid}] ERROR {e!r}')
