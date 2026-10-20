import re, sys, difflib
src = open('/Users/albertogarciaplanes/tmpradio/source/generated-radio.txt').read().split('\f')
txt = '\n'.join(src[62:76])
typ = open('/Users/albertogarciaplanes/tmpradio/chapters/t03.typ').read()
def norm(s):
    s = s.replace('-\n','').replace('\n',' ')
    s = re.sub(r'[^a-záéíóúñüA-ZÁÉÍÓÚÑÜ]+',' ',s).lower()
    return ' '.join(s.split())
T = norm(typ)
# words of length>=4 sequences: check 6-word windows from source sentences
sents = re.split(r'(?<=[.:;])\s+', txt.replace('\n',' '))
missing=[]
for snt in sents:
    w = norm(snt).split()
    if len(w) < 6: continue
    hits=0; tot=0
    for i in range(0, len(w)-5, 3):
        tot+=1
        if ' '.join(w[i:i+6]) in T: hits+=1
    if tot and hits/tot < 0.6:
        missing.append((round(hits/tot,2), snt.strip()[:160]))
for m in missing: print(m)
