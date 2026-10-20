import re, sys, unicodedata
src = open('/Users/albertogarciaplanes/tmpradio/source/generated-radio.txt').read().split('\f')
a, b, f, pre = int(sys.argv[1]), int(sys.argv[2]), sys.argv[3], sys.argv[4]
txt = '\n'.join(src[a-1:b])
typ = open(f).read()
def norm(s):
    s = unicodedata.normalize('NFKC', s)
    return re.sub(r'[^a-záéíóúñü0-9]', '', s.lower())
T = norm(typ)
# find question blocks
blocks = re.split(r'\n\s*(?=' + re.escape(pre) + r'\.\d+ )', txt)
n=0
for bl in blocks:
    m = re.match(re.escape(pre) + r'\.(\d+) ', bl.strip())
    if not m: continue
    n+=1
    lines = bl.strip().split('\n')
    stem = []
    opts = []
    for ln in lines:
        mm = re.match(r'\s*([a-d])\) (.*)', ln)
        if mm: opts.append(mm.group(2).strip())
        elif not opts: stem.append(ln.strip())
    st = norm(' '.join(stem))
    st = st[len(norm(pre))+len(m.group(1)):]
    ok = st[:60] in T
    for o in opts:
        if norm(o) not in T: print(pre, m.group(1), 'OPT MISS:', o)
    if not ok: print(pre, m.group(1), 'STEM?', ' '.join(stem)[:100])
print('questions parsed', n)
