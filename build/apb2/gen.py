import sys, re, json
sys.path.insert(0, '/Users/albertogarciaplanes/tmpradio/build/apb2')
from parse import parse_B, parse_D
from join import joinlines

secs, qs, ojo = parse_B()
items, tables = parse_D()

# ---------------------------------------------------------------- patches
# id -> list of (old, new); new may contain ⟦T⟧typst⟦/T⟧ pass-through
PATCH = {
    'C-R3.8': [
        ('18 ⟦x⟧×⟦/x⟧ 18', '18 × 18'),
        ('10 ⟦x⟧×⟦/x⟧ 10', '10 × 10'),
        ('24 ⟦x⟧×⟦/x⟧ 24', '24 × 24'),
        ('⟦x⟧20⟦/x⟧⟦x⟧◦⟦/x⟧', '20°'),
        ('⟦x⟧10⟦/x⟧⟦x⟧◦⟦/x⟧', '10°'),
        ('⟦x⟧2⟦/x⟧⟦x⟧◦⟦/x⟧', '2°'),
        ('⟦x⟧1⟦/x⟧⟦x⟧◦⟦/x⟧', '1°'),
    ],
    'C-R6.2': [
        ('⟦x⟧145⟦/x⟧⟦x⟧,⟦/x⟧⟦x⟧000⟦/x⟧⟦x⟧+⟦/x⟧⟦x⟧0⟦/x⟧⟦x⟧,⟦/x⟧⟦x⟧600⟦/x⟧ ⟦x⟧=⟦/x⟧ ⟦x⟧145⟦/x⟧⟦x⟧,⟦/x⟧⟦x⟧600⟦/x⟧',
         '⟦T⟧$145,000 + 0,600 = 145,600$⟦/T⟧'),
        ('⟦x⟧145⟦/x⟧⟦x⟧,⟦/x⟧⟦x⟧1875⟦/x⟧⟦x⟧+⟦/x⟧⟦x⟧0⟦/x⟧⟦x⟧,⟦/x⟧⟦x⟧600⟦/x⟧ ⟦x⟧=⟦/x⟧ ⟦x⟧145⟦/x⟧⟦x⟧,⟦/x⟧⟦x⟧7875⟦/x⟧',
         '⟦T⟧$145,1875 + 0,600 = 145,7875$⟦/T⟧'),
    ],
    'C-R8.8': [
        ('⟦x⟧𝑁⟦/x⟧ va de ⟦x⟧0⟦/x⟧⟦x⟧,⟦/x⟧⟦x⟧3⟦/x⟧ ⟦x⟧×⟦/x⟧ ⟦x⟧10⟦/x⟧⟦x⟧𝑁⟦/x⟧ a ⟦x⟧3⟦/x⟧ ⟦x⟧×⟦/x⟧ ⟦x⟧10⟦/x⟧⟦x⟧𝑁⟦/x⟧ Hz',
         '⟦T⟧$N$⟦/T⟧ va de ⟦T⟧#box[$0,3 times 10^N$]⟦/T⟧ a ⟦T⟧#box[$3 times 10^N$]⟦/T⟧ Hz'),
    ],
    'C-R8.46': [
        ('mW/cm⟦x⟧2⟦/x⟧', 'mW/cm⟦T⟧#super[2]⟦/T⟧'),
    ],
}

def esc(t):
    # escape Typst markup specials in plain text
    out = []
    for ch in t:
        if ch in '\\#$*_@<~`':
            out.append('\\' + ch)
        else:
            out.append(ch)
    return ''.join(out)

def fix_vease(s):
    out = ''
    i = 0
    while True:
        j = s.find('(Véase', i)
        if j < 0:
            out += s[i:]
            break
        pre = s[i:j]
        if pre.endswith('⟦i⟧'):
            pre = pre[:-3]
        out += pre
        depth = 0
        k = j
        buf = ''
        while k < len(s):
            if s.startswith('⟦', k):
                k = s.index('⟧', k) + 1
                continue
            c = s[k]
            buf += c
            k += 1
            if c == '(':
                depth += 1
            elif c == ')':
                depth -= 1
                if depth == 0:
                    break
        else:
            raise SystemExit('unbalanced Véase: ' + s[j:j+80])
        if s.startswith('⟦/i⟧', k):
            k += 4
        out += '⟦V⟧' + buf + '⟦/V⟧'
        i = k
    return out

def to_typst(m):
    """markup (with ⟦i⟧ ⟦b⟧ ⟦x⟧ ⟦T⟧ markers) -> Typst content source"""
    ph = []
    def grab(mm):
        ph.append(mm.group(1))
        return '\x01%d\x02' % (len(ph) - 1)
    m = re.sub(r'⟦T⟧(.*?)⟦/T⟧', grab, m)
    if '⟦x⟧' in m:
        raise SystemExit('unpatched math font: ' + m)
    # parenthetical cross-references (Véase ...) in italics
    m = fix_vease(m)
    m = esc(m)
    m = m.replace('⟦V⟧', '#vease[').replace('⟦/V⟧', ']')
    m = m.replace('⟦i⟧', '#emph[').replace('⟦/i⟧', ']')
    m = m.replace('⟦b⟧', '#strong[').replace('⟦/b⟧', ']')
    m = re.sub('\x01(\\d+)\x02', lambda mm: ph[int(mm.group(1))], m)
    if '⟦' in m or '⟧' in m:
        raise SystemExit('leftover marker: ' + m)
    return m

# ---------------------------------------------------------------- B questions
bq = {}
order = []
for q in qs:
    stem = joinlines(q['stem'])
    opts = [joinlines(o) for o in q['opts']]
    assert len(opts) == 4, q['id']
    bq[q['id']] = dict(stem=stem, opts=opts, sec=q['sec'], page=q['page'])
    order.append(q['id'])

# ---------------------------------------------------------------- D solutions
dq = {}
dorder = []
for k, it in items:
    if k != 'Q':
        continue
    paras = []   # list of [kind, [lines]]
    for kd, t in it['lines']:
        if kd in ('noest', 'clave'):
            paras.append([kd, [t]])
        elif kd == 'sol':
            paras.append(['sol', [t]])
        else:
            if not paras:
                paras.append(['sol', [t]])
            else:
                paras[-1][1].append(t)
    paras = [(kd, joinlines(ls)) for kd, ls in paras]
    dq[it['id']] = dict(ans=it['ans'], paras=paras, page=it['page'])
    dorder.append(it['id'])

assert order == dorder, 'order mismatch B vs D'

# ---------------------------------------------------------------- answer tables cross-check
tab = []
rows = []
for name, vals in tables:
    rows.append((name, vals))
nums = []
letters = []
for i in range(0, len(rows), 2):
    assert rows[i][0] == 'Pregunta' and rows[i + 1][0] == 'Respuesta'
    assert len(rows[i][1]) == len(rows[i + 1][1])
    letters += rows[i + 1][1]
rq = [i for i in order if not i.startswith('C-H.')]
assert len(rq) == len(letters), (len(rq), len(letters))
for i, l in zip(rq, letters):
    if dq[i]['ans'] != l:
        print('ANS MISMATCH', i, dq[i]['ans'], l)

# ---------------------------------------------------------------- patches + C-H handling
for i in order:
    d = dq[i]
    new = []
    for kd, t in d['paras']:
        for old, nw in PATCH.get(i, []):
            t = t.replace(old, nw)
        new.append((kd, t))
    d['paras'] = new
    if i.startswith('C-H.'):
        assert len(d['paras']) == 1, i
        t = d['paras'][0][1]
        m = re.match(r'^Clave de los bancos antiguos: ⟦b⟧([a-d])⟦/b⟧\. Según la norma vigente: (.*)$', t)
        assert m, (i, t[:120])
        d['ans'] = m.group(1)
        rest = m.group(2)
        assert '⟦b⟧Consejo:⟦/b⟧' in rest, i
        t2 = 'Clave de los bancos antiguos: ⟦b⟧%s⟦/b⟧. ⟦b⟧Según la norma vigente:⟦/b⟧ %s' % (m.group(1), rest)
        d['paras'] = [('sol', t2)]

# ---------------------------------------------------------------- emit Typst
HEADER = r'''// Apéndice B (continuación): preguntas complementarias B.11–B.19
// Temas R1–R9 y preguntas heredadas del régimen anterior (C-H).
// Modo FIEL: transcripción de las preguntas del apéndice B y de las
// soluciones razonadas de D.20 (páginas PDF 244–263 y 400–424).
// El apéndice B lo abre ap-b1.typ; este archivo continúa con la sección B.11.
#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// ---- única ayuda local (prefijo _apb2-): párrafo «CLAVE DE LOS BANCOS PÚBLICOS» de D.20
// (#no-esta y #vease vienen de la plantilla)
#let _apb2-clave(cuerpo) = block(above: 0.7em, below: 0.3em, {
  set text(size: 0.92em)
  text(font: fuente-sans, size: 0.88em, weight: "bold", tracking: 0.04em, fill: col.senal2, smallcaps[clave de los bancos públicos])
  h(0.55em)
  cuerpo
})

'''

def sol_src(paras):
    chunks = []
    for kd, t in paras:
        s = to_typst(t)
        if kd == 'noest':
            s = '#no-esta[' + s + ']'
        elif kd == 'clave':
            s = '#_apb2-clave[' + s + ']'
        chunks.append(s)
    return '\n\n    '.join(chunks)

secnames = [re.sub(r'^B\.\d+\.\s+', '', s) for s in secs]
out = [HEADER]
cur_sec = -1
for i in order:
    b = bq[i]
    if b['sec'] != cur_sec:
        cur_sec = b['sec']
        out.append('== ' + secnames[cur_sec - 1] + '\n')
        if secnames[cur_sec - 1].startswith('Preguntas heredadas'):
            out.append('@@OJO@@\n')
    d = dq[i]
    opts = ', '.join('[' + to_typst(o) + ']' for o in b['opts'])
    out.append('#q("%s", "%s",\n  [%s],\n  (%s),\n  sol: [%s],\n)\n' % (i, d['ans'], to_typst(b['stem']), opts, sol_src(d['paras'])))

text = '\n'.join(out)
ojo_text = joinlines(ojo)
ojo_text = re.sub(r'^¿OJO! ', '', ojo_text)
text = text.replace('@@OJO@@', '#ojo[' + to_typst(ojo_text) + ']')
open('/Users/albertogarciaplanes/tmpradio/chapters/ap-b2.typ', 'w').write(text)
print('written', len(order), 'questions;', len(text), 'chars')
