import re, sys, subprocess, unicodedata
from collections import Counter
sys.path.insert(0,'/Users/albertogarciaplanes/tmpradio/build/apb1')
import s2, s3, s4

def norm(t):
    t = unicodedata.normalize('NFKC', t)
    t = re.sub(r'-\n(?=[a-záéíóúüñ])', '', t)
    return t

def words(t):
    return re.findall(r"[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]{3,}", t)

pdf = subprocess.run(['pdftotext','/Users/albertogarciaplanes/tmpradio/build/ap-b1.pdf','-'],capture_output=True,text=True).stdout
pdf = norm(pdf)
# split into questions part and solutions part
i = pdf.index('Soluciones del grupo C-T1')
qpart, spart = pdf[:i], pdf[i:]
# solutions
entries,_ = s2.solutions()
bounds = [(m.start(), m.group(1)) for m in re.finditer(r'(C-T\d+\.\d+) \([a-d]\)', spart)]
got = {}
for k,(pos,id_) in enumerate(bounds):
    end = bounds[k+1][0] if k+1 < len(bounds) else len(spart)
    got[id_] = spart[pos:end]
print('solutions in pdf:', len(got), 'expected', len(entries))
tot_missing = 0
for e in entries:
    src = ' '.join(s2.plain(t) for k,t in e['paras'])
    src = ''.join(s3.demath(c) for c in src)
    ws = Counter(words(src))
    pw = Counter(words(got.get(e['id'],'')))
    miss = ws - pw
    extra = pw - ws
    # ignore 'Tema' table words
    if miss or extra:
        print(e['id'], 'MISSING', dict(miss), 'EXTRA', dict(extra))
