import re, sys, unicodedata
src = open('/Users/albertogarciaplanes/tmpradio/source/generated-radio.txt').read().split('\f')
a, b, f = int(sys.argv[1]), int(sys.argv[2]), sys.argv[3]
txt = '\n'.join(src[a-1:b])
typ = open(f).read()
def norm(s):
    s = unicodedata.normalize('NFKC', s)
    s = re.sub(r'[^a-záéíóúñü]', '', s.lower())
    return s
T = norm(typ)
# join hyphenated lines
txt = re.sub(r'-\n\s*', '', txt)
txt = re.sub(r'\s+', ' ', txt)
sents = re.split(r'(?<=[.:;])\s+', txt)
miss = 0
for snt in sents:
    n = norm(snt)
    if len(n) < 25: continue
    # check chunks of 20 chars
    chunks = [n[i:i+18] for i in range(0, len(n)-18, 18)]
    found = sum(1 for c in chunks if c in T)
    if chunks and found / len(chunks) < 0.6:
        miss += 1
        print('MISS:', snt[:160])
print('misses', miss)
