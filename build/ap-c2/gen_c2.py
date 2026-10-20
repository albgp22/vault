# ap-c2 generator: parsed_c2.json + ovr_t.py + fmt_r.py -> chapters/ap-c2.typ
import re, json, sys
sys.path.insert(0, '/Users/albertogarciaplanes/tmpradio/build/ap-c2')
from ovr_t import OVR, FMT as FMT_T
from fmt_r import FMT as FMT_R, QF, QOVR
FMT = {}; FMT.update(FMT_T); FMT.update(FMT_R)
D = json.load(open('/Users/albertogarciaplanes/tmpradio/build/ap-c2/parsed_c2.json'))

GEN_RE = re.compile(r'\bQ[A-Z]{2}\b\??|\bRST\b|\b(?:SWL|GL|GM|GN|GE|SSB|CQ)\b')
BAD = re.compile('[\U0001D400-\U0001D7FF√∞→◦∼ℎΔ]')
used_fmt = set(); used_ovr = set()

def escape(s):
    return re.sub(r'([\\#$@<*_`])', r'\\\1', s)

def process(raw, pairs=(), generic=False, where=''):
    store = []
    def ph(new):
        store.append(new); return '\x01%d\x02' % (len(store) - 1)
    for old, new in sorted(pairs, key=lambda p: -len(p[0])):
        if old not in raw: raise Exception('FMT not found in %s: %r' % (where, old))
        raw = raw.replace(old, ph(new))
    if generic:
        raw = GEN_RE.sub(lambda m: ph('#_apc2-m[%s]' % m.group(0)), raw)
    raw = raw.replace('𝜇', 'μ').replace('𝑄', ph('$Q$'))
    raw = re.sub(r'(?<=\d{2}) (?=000\b)', lambda m: ph('~'), raw)
    if BAD.search(raw): raise Exception('math char left in %s: %r' % (where, raw))
    s = escape(raw)
    if '//' in s.replace('\x01', '').replace('\x02', ''): print('WARNING // in', where)
    s = re.sub('\x01(\\d+)\x02', lambda m: store[int(m.group(1))], s)
    # un «;» pegado a #f[...] lo absorbe el modo código: se escapa
    return re.sub(r'(#_apc2-m\[[^\]]*\]);', r'\1\\;', s)

def split_tail(text):
    i = text.rfind('(Véase ')
    if i < 0: return text.rstrip(), None
    j = text.rfind('.)') + 2
    return text[:i].rstrip(), text[i:j]

def build_sol(qid, paras):
    generic = qid.startswith(('F-R2.', 'F-R3.'))
    out = []
    for idx, (noest, raw) in enumerate(paras):
        key = '%s:%d' % (qid, idx)
        tail = None
        if not noest:
            body, tail = split_tail(raw)
        else:
            body = raw
        if key in OVR:
            used_ovr.add(key); text = OVR[key]
        else:
            pairs = FMT.get(key, [])
            if pairs: used_fmt.add(key)
            text = process(body, pairs, generic, key)
        if noest:
            out.append('#no-esta[%s]' % text)
        else:
            s = text
            if tail:
                s += ' #vease[%s]' % process(tail, (), generic, key + ':tail')
            out.append(s)
    return ' '.join(out)

def label(h):
    m = re.match(r'Tema ([TR]\d+)', h)
    return 'apc2-sec-' + m.group(1).lower()

lines = []
lines.append('''// Apéndice C (parte 2): C.4 Tema T4 … C.15 Tema R7 del «Refuerzo del temario» (agente ap-c2, modo FIEL).
// Preguntas F-T4 … F-R7 con su clave y su solución razonada (D.21). No llama a #apendice (lo abre ap-c1).
#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// Código de llamada, grupos Q y abreviaturas: el original los compone en monoespaciada (local: ap-c2).
#let _apc2-m(t) = text(font: "DejaVu Sans Mono", size: 0.82em, t)
''')
count = {}
for h, qs in D['sections']:
    lines.append('== %s <%s>\n' % (h, label(h)))
    for q in qs:
        qid = q['id']; s = D['sols'][qid]
        generic = qid.startswith(('F-R2.', 'F-R3.'))
        stem = QOVR.get((qid, 's')) or process(q['stem'], QF.get((qid, 's'), []), generic, qid + ':s')
        if (qid, 's') in QF: used_fmt.add((qid, 's'))
        opts = []
        for i, o in enumerate(q['opts']):
            if (qid, i) in QOVR: opts.append(QOVR[(qid, i)]); continue
            if (qid, i) in QF: used_fmt.add((qid, i))
            opts.append(process(o, QF.get((qid, i), []), generic, '%s:o%d' % (qid, i)))
        sol = build_sol(qid, s['paras'])
        lines.append('#q("%s", "%s",\n  [%s],\n  (%s),\n  sol: [%s],\n)\n' % (
            qid, s['ans'], stem, ', '.join('[%s]' % o for o in opts), sol))
        g = qid.rsplit('.', 1)[0]; count[g] = count.get(g, 0) + 1
# sanity: every override/format used
for k in OVR:
    if k not in used_ovr: print('UNUSED OVR', k)
for k in FMT:
    if k not in used_fmt: print('UNUSED FMT', k)
for k in QF:
    if k not in used_fmt: print('UNUSED QF', k)
open('/Users/albertogarciaplanes/tmpradio/chapters/ap-c2.typ', 'w').write('\n'.join(lines))
print(count, sum(count.values()))
