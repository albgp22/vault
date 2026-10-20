# Generator for custom Falstad (CircuitJS) circuits. Writes <id>.txt and urls.json.
import json, os, sys, math, urllib.parse
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from lz import compress_uri, decompress_uri

BASE = "https://www.falstad.com/circuit/circuitjs.html?"
SUFFIX = "&lang=es&euroResistors=true"
OUT = os.path.dirname(os.path.abspath(__file__))


def esc(s):
    """Escape text for CircuitJS text-format tokens."""
    return s.replace("\\", "\\\\").replace(" ", "\\s").replace("+", "\\p").replace("=", "\\q").replace("#", "\\h").replace("&", "\\a")


def num(v):
    if isinstance(v, int):
        return str(v)
    r = repr(float(v))
    if r.endswith(".0"):
        r = r[:-2]
    return r


class Circuit:
    def __init__(self, cid, dt, speed, vrange=5, current_bar=50, flags=1):
        self.cid = cid
        self.header = f"$ {flags} {num(dt)} {num(speed)} {current_bar} {num(vrange)} 50 5e-11"
        self.lines = []
        self.names = {}
        self.scopes = []

    def add(self, line, name=None):
        if name:
            assert name not in self.names, name
            self.names[name] = len(self.lines)
        self.lines.append(line)
        return len(self.lines) - 1

    # --- elements -------------------------------------------------------
    def w(self, x1, y1, x2, y2, name=None):
        return self.add(f"w {x1} {y1} {x2} {y2} 0", name)

    def r(self, x1, y1, x2, y2, ohms, name=None):
        return self.add(f"r {x1} {y1} {x2} {y2} 0 {num(ohms)}", name)

    def c(self, x1, y1, x2, y2, farads, name=None, v0=0):
        return self.add(f"c {x1} {y1} {x2} {y2} 0 {num(farads)} {num(v0)}", name)

    def l(self, x1, y1, x2, y2, henries, name=None):
        return self.add(f"l {x1} {y1} {x2} {y2} 0 {num(henries)} 0", name)

    def g(self, x, y, name=None):
        return self.add(f"g {x} {y} {x} {y + 16} 0", name)

    def d(self, x1, y1, x2, y2, name=None):
        # anode at (x1,y1), cathode at (x2,y2), default 0.805904783 V model
        return self.add(f"d {x1} {y1} {x2} {y2} 1 0.805904783", name)

    def z(self, x1, y1, x2, y2, vz, name=None):
        # anode at (x1,y1), cathode at (x2,y2)
        return self.add(f"z {x1} {y1} {x2} {y2} 1 0.805904783 {num(vz)}", name)

    def v(self, x1, y1, x2, y2, wf, freq, vmax, bias=0, phase=0, duty=0.5, name=None):
        # (x2,y2) is the + terminal. wf: 0 DC, 1 AC, 2 square, 3 triangle
        return self.add(f"v {x1} {y1} {x2} {y2} 0 {wf} {num(freq)} {num(vmax)} {num(bias)} {num(phase)} {num(duty)}", name)

    def rail(self, x1, y1, x2, y2, wf, freq, vmax, bias=0, phase=0, duty=0.5, name=None):
        # post at (x1,y1); referenced to ground
        return self.add(f"R {x1} {y1} {x2} {y2} 0 {wf} {num(freq)} {num(vmax)} {num(bias)} {num(phase)} {num(duty)}", name)

    def sweep(self, x1, y1, x2, y2, fmin, fmax, vmax, tsweep, log=True, bidir=True, name=None):
        flags = (1 if log else 0) | (2 if bidir else 0)
        return self.add(f"170 {x1} {y1} {x2} {y2} {flags} {num(fmin)} {num(fmax)} {num(vmax)} {num(tsweep)}", name)

    def am(self, x1, y1, x2, y2, fc, fm, vmax, name=None):
        return self.add(f"200 {x1} {y1} {x2} {y2} 0 {num(fc)} {num(fm)} {num(vmax)}", name)

    def fm(self, x1, y1, x2, y2, fc, fmod, vmax, dev, name=None):
        return self.add(f"201 {x1} {y1} {x2} {y2} 0 {num(fc)} {num(fmod)} {num(vmax)} {num(dev)}", name)

    def trans(self, x1, y1, x2, y2, pnp=1, flip=False, beta=100, name=None):
        """General BJT. (x1,y1) = base post, (x2,y2) = body direction. Returns (base, collector, emitter)."""
        dx, dy = x2 - x1, y2 - y1
        dsign = (1 if dx > 0 else -1) if dy == 0 else (1 if dy > 0 else -1)
        if flip:
            dsign = -dsign
        hs2 = 16 * dsign * pnp
        gx, gy = dy, x1 - x2
        g = hs2 / math.hypot(gx, gy)
        coll = (math.floor(x2 + g * gx + .48), math.floor(y2 + g * gy + .48))
        emit = (math.floor(x2 - g * gx + .48), math.floor(y2 - g * gy + .48))
        fl = 1 if flip else 0
        self.add(f"t {x1} {y1} {x2} {y2} {fl} {pnp} 0 0 {num(beta)}", name)
        return (x1, y1), coll, emit

    def npn(self, xb, yb, name=None, beta=100):
        # base post at (xb,yb); collector at (xb+64, yb-16), emitter at (xb+64, yb+16)
        return self.trans(xb, yb, xb + 64, yb, 1, False, beta, name)

    def pnp(self, xb, yb, name=None, beta=100):
        # base post at (xb,yb); emitter at (xb+64, yb-16), collector at (xb+64, yb+16)
        return self.trans(xb, yb, xb + 64, yb, -1, False, beta, name)

    def T(self, x1, y1, x2, lprim, ratio, k=0.999, name=None):
        # primary posts (x1,y1),(x1,y1+32); secondary posts (x2,y1),(x2,y1+32)
        return self.add(f"T {x1} {y1} {x2} {y1} 0 {num(lprim)} {num(ratio)} 0 0 {num(k)}", name)

    def vcvs(self, x, y, expr, name=None):
        # inputs A (x,y), B (x,y+32); outputs V+ (x+96,y), V- (x+96,y+32)
        return self.add(f"213 {x} {y} {x + 32} {y} 0 2 {esc(expr)}", name)

    def probe(self, x1, y1, x2, y2, meter=1, name=None):
        # voltmeter; meter 0 = instantaneous, 1 = RMS, 2 = max
        return self.add(f"p {x1} {y1} {x2} {y2} 1 {meter} 0", name)

    def text(self, x, y, s, size=14, name=None):
        return self.add(f"x {x} {y} {x + 8 * len(s)} {y + 4} 4 {size} {esc(s)}", name)

    # --- scopes ---------------------------------------------------------
    def scope(self, plots, speed, position, showI=False, showV=True, fft=False, label=None,
              scaleV=5, scaleA=0.1, extra=0):
        """plots: list of (name, value[, acflag]); value 0 = voltage, 3 = current, 2 = Ic (transistor),
        7 = power."""
        flags = 4096 | (1 if showI else 0) | (2 if showV else 0) | (1024 if fft else 0) | extra
        acs = [p[2] if len(p) > 2 else 0 for p in plots]
        if any(acs):
            flags |= 1 << 18
        first = plots[0]
        toks = ["o", str(self.names[first[0]]), str(speed), str(first[1]), str(flags), num(scaleV), num(scaleA),
                str(position), str(len(plots))]
        if first[1] == 7:
            toks.append("1")
        for i, p in enumerate(plots):
            if flags & (1 << 18):
                toks.append(format(acs[i], "x"))
            if i:
                toks += [str(self.names[p[0]]), str(p[1])]
                if p[1] == 7:
                    toks.append("1")
        if label:
            toks.append(esc(label))
        self.scopes.append(" ".join(toks))

    def text_dump(self):
        return "\n".join([self.header] + self.lines + self.scopes) + "\n"

    def urls(self):
        t = self.text_dump()
        ctz = compress_uri(t)
        assert decompress_uri(ctz) == t
        return {"ctz": BASE + "ctz=" + ctz + SUFFIX}


CIRCUITS = {}


def circuit(fn):
    CIRCUITS[fn.__name__.replace("_", "-")] = fn
    return fn


def build(ids=None):
    res = {}
    for cid, fn in CIRCUITS.items():
        if ids and cid not in ids:
            continue
        k = fn()
        txt = k.text_dump()
        with open(os.path.join(OUT, cid + ".txt"), "w") as f:
            f.write(txt)
        res[cid] = {"url": k.urls()["ctz"], "names": k.names, "nlines": len(k.lines)}
    old = {}
    p = os.path.join(OUT, "urls.json")
    if os.path.exists(p):
        old = json.load(open(p))
    old.update(res)
    json.dump(old, open(p, "w"), indent=1, ensure_ascii=False)
    return res


if __name__ == "__main__":
    r = build(sys.argv[1:] or None)
    for cid, v in r.items():
        print(cid, len(v["url"]), v["url"])
