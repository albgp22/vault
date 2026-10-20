import re, sys, subprocess, unicodedata, difflib
from collections import Counter
L = lambda t: re.sub(r'[^A-Za-zÁÉÍÓÚÜÑáéíóúüñ]', '', unicodedata.normalize('NFKC', t))
src = open('/Users/albertogarciaplanes/tmpradio/build/apb1/apb1-q.txt').read()
# cut at B.11
src = src[:src.index('B.11.')]
# drop headers
lines = []
for ln in src.split('\n'):
    s = ln.strip()
    if re.match(r'^B PReguntas complementaRias$', s): continue
    if re.match(r'^B\.\d+ Tema', s): continue
    if re.match(r'^\d+$', s): continue
    lines.append(ln)
src = '\n'.join(lines)
src = src[src.index('C-T1.1 '):]
# remove section headings "B.n.   Tema ..."
src = re.sub(r'\nB\.\d+\.\s+Tema [^\n]*', '', src)
blocks = re.split(r'\n(?=C-T\d+\.\d+ )', src)
S = {}
for b in blocks:
    m = re.match(r'(C-T\d+\.\d+) ', b)
    S[m.group(1)] = b
pdf = subprocess.run(['pdftotext','/Users/albertogarciaplanes/tmpradio/build/ap-b1.pdf','-'],capture_output=True,text=True).stdout
pdf = unicodedata.normalize('NFKC', pdf)
pdf = re.sub(r'-\n(?=[a-záéíóúüñ])', '', pdf)
i = pdf.index('Soluciones del grupo C-T1')
qp = pdf[:i]
qp = qp[qp.index('C-T1.1 En'):]
qb = [(m.start(), m.group(1)) for m in re.finditer(r'(?m)^(C-T\d+\.\d+) ', qp)]
P = {}
for k,(pos,id_) in enumerate(qb):
    end = qb[k+1][0] if k+1 < len(qb) else len(qp)
    P[id_] = qp[pos:end]
print(len(S), len(P))
nd = 0
for id_ in S:
    a = L(S[id_]); b = L(P[id_])
    # remove header artifacts in pdf: section titles and running header
    for h in ['Preguntascomplementarias','TemaTTeoríadelaelectricidadelelectromagnetismoylaradio','TemaTComponentes','TemaTCircuitos','TemaTReceptores','TemaTTransmisores','TemaTAntenasylíneasdetransmisión','TemaTPropagación','TemaTMedidas','TemaTInterferenciaeinmunidad','TemaTSeguridad']:
        b = b.replace(h,'')
        a = a.replace(h,'')
    if a != b:
        if Counter(a) == Counter(b):
            print(id_, 'same letters, different order (figure?)')
        else:
            sm = difflib.SequenceMatcher(None, a, b, autojunk=False)
            blocks_ = [(tag, a[i1:i2], b[j1:j2]) for tag,i1,i2,j1,j2 in sm.get_opcodes() if tag != 'equal']
            print(id_, blocks_[:5])
        nd += 1
print('differences', nd)
