#!/usr/bin/env python3
import re, sys, importlib
sys.path.insert(0, '/Users/albertogarciaplanes/tmpradio/build/apb1')
import s2, s3, s4, s5
import figs
importlib.reload(figs)

HEAD = open('/Users/albertogarciaplanes/tmpradio/build/apb1/head.typ', encoding='utf-8').read()

SECTIONS = {
    1: 'Tema T1. Teoría de la electricidad, el electromagnetismo y la radio',
    2: 'Tema T2. Componentes',
    3: 'Tema T3. Circuitos',
    4: 'Tema T4. Receptores',
    5: 'Tema T5. Transmisores',
    6: 'Tema T6. Antenas y líneas de transmisión',
    7: 'Tema T7. Propagación',
    8: 'Tema T8. Medidas',
    9: 'Tema T9. Interferencia e inmunidad',
    10: 'Tema T10. Seguridad',
}


def opening():
    lines = s2.get_lines('q.xml')
    L = [(c, t) for n, c, t in lines if n == 217]
    def seg(lo, hi):
        return [t for c, t in L if lo <= c <= hi]
    intro, _ = s2.join_lines(seg(390, 540))
    # legend rows
    def row(lo, hi):
        txt, _ = s2.join_lines(seg(lo, hi))
        return txt
    r1 = row(575, 600)
    r2 = row(610, 636)
    r3 = row(648, 672)
    r4 = row(684, 690)
    ojo, _ = s2.join_lines(seg(740, 810))
    nota, _ = s2.join_lines(seg(850, 930))
    from s1 import B0, B1
    def strip_label(t, lab):
        t2 = re.sub(r'^' + B0 + re.escape(lab) + B1 + r'\s*', '', t)
        assert t2 != t, (lab, t[:60])
        return t2
    out = {}
    out['intro'] = s3.convert_para(intro)
    # legend: (term, definition)
    out['legend'] = [
        ('C-T6.3', s3.convert_para(strip_label(r1, 'C-T6.3'))),
        ('NO ESTÁ EN EL TEXTO', s3.convert_para(strip_label(r2, 'NO ESTÁ EN EL TEXTO'))),
        ('CLAVE DE LOS BANCOS PÚBLICOS', s3.convert_para(re.sub(B0 + 'PÚBLICOS' + B1 + r'\s*', '', strip_label(r3, 'CLAVE DE LOS BANCOS')))),
        ('Preguntas heredadas', s3.convert_para(strip_label(r4, 'Preguntas heredadas'))),
    ]
    out['ojo'] = s3.convert_para(strip_label(ojo, '¿OJO!'))
    out['nota'] = s3.convert_para(strip_label(nota, 'NOTA'))
    return out


def wrapc(text, width, head='', tail=''):
    ls = s5.wrap(text, width)
    ls[0] = head + ls[0]
    ls[-1] = ls[-1] + tail
    return ls


def build():
    qs, conv, ans = s5.main(None)
    op = opening()
    out = [HEAD.rstrip('\n'), '']
    out.append('#apendice("B", "Preguntas complementarias")')
    out.append('')
    out += s5.wrap(op['intro'], 100)
    out.append('')
    out.append('#block(above: 1.2em, breakable: false, {')
    out.append('  show table.cell.where(y: 0): set text(font: fuente-texto, weight: "regular", size: 1em)')
    out.append('  set text(size: 9.5pt)')
    out.append('  table(')
    out.append('    columns: (auto, 1fr),')
    out.append('    stroke: none,')
    out.append('    inset: (x: 6pt, y: 2.5pt),')
    out.append('    table.hline(stroke: 0.7pt),')
    for term, d in op['legend']:
        out.append('    [*%s*], [%s],' % (s3.esc(term), d))
    out.append('    table.hline(stroke: 0.7pt),')
    out.append('  )')
    out.append('})')
    out.append('')
    out += wrapc(op['ojo'], 100, '#ojo[', ']')
    out.append('')
    out += wrapc(op['nota'], 100, '#nota[', ']')
    out.append('')
    cur = None
    for q in qs:
        g = int(re.match(r'C-T(\d+)', q['id']).group(1))
        if g != cur:
            cur = g
            out.append('== %s <apb1-t%d>' % (SECTIONS[g], g))
            out.append('')
        out += qcall(q, conv[q['id']], ans[q['id']])
        out.append('')
    return '\n'.join(out)


def qcall(q, cv, an):
    L = []
    qid = q['id']
    L.append('#q("%s", "%s",' % (qid, an))
    # stem
    if qid in s4.FIG and qid not in figs.STEM:
        L.append('  [FIGURA PENDIENTE],')
    elif qid in figs.STEM:
        stem = figs.STEM[qid]
        L.append('  [' + stem + '],' if '\n' not in stem else '  [' + stem + '],')
    else:
        L += wrapc(s3.convert_para(q['stem']), 98, '  [', '],')
    # options
    if qid in figs.OPTS:
        L.append('  (')
        for o in figs.OPTS[qid]:
            L.append('    [' + o + '],')
        L.append('  ),')
    elif qid in s4.FIG and len(q['opts']) != 4:
        L.append('  ([a], [b], [c], [d]),')
    else:
        L.append('  (')
        for o in q['opts']:
            L += wrapc(s3.convert_para(o), 96, '    [', '],')
        L.append('  ),')
    # solution
    sl = s5.sol_content({}, cv)
    L.append('  sol: [')
    for l in sl:
        L.append('    ' + l)
    L.append('  ],')
    L.append(')')
    return L


if __name__ == '__main__':
    txt = build()
    open('/Users/albertogarciaplanes/tmpradio/chapters/ap-b1.typ', 'w', encoding='utf-8').write(txt + '\n')
    print(len(txt.splitlines()), 'lines')
