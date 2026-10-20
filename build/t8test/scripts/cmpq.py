import re, sys
src = open('/Users/albertogarciaplanes/tmpradio/source/generated-radio.txt').read().split('\f')
pages = {'T8': range(112,118), 'T9': range(118,122), 'T10': range(122,130)}
def norm(t):
    t = t.replace('­','')
    t = re.sub(r'-\n\s*', '', t)        # hyphenation
    t = re.sub(r'\s+', ' ', t).strip()
    return t
def srcq(grp):
    txt = '\n'.join(src[i] for i in pages[grp])
    # remove page headers/footers lines that are just numbers or running heads
    lines = [l for l in txt.split('\n') if not re.match(r'^\s*\d{3}\s*$', l)]
    txt = '\n'.join(lines)
    out = {}
    for m in re.finditer(r'^%s\.(\d+) (.*?)(?=^%s\.\d+ |^T\d+\.\d+\.\s{2,}|\Z)' % (grp, grp), txt, re.S | re.M):
        n = int(m.group(1)); body = m.group(2)
        parts = re.split(r'^\s*([a-d])\) ', body, flags=re.M)
        stem = norm(parts[0]); opts = [norm(parts[i+1]) for i in range(1, len(parts)-1, 2)]
        out[n] = (stem, opts)
    return out
def myq(path, grp):
    s = open(path).read()
    out = {}
    for m in re.finditer(r'#q\("%s\.(\d+)", "([a-d])",\n  \[(.*?)\],\n  \((.*?)\),\n  sol:' % grp, s, re.S):
        n = int(m.group(1)); stem = m.group(3); opts = re.findall(r'\[(.*?)\](?:,|$)', m.group(4))
        out[n] = (norm(stem), [norm(o) for o in opts])
    return out
def clean(t):
    t = re.sub(r'_([^_]*)_', r'\1', t)
    t = t.replace('$', '').replace('\\', '')
    return t
grp, path = sys.argv[1], sys.argv[2]
a = srcq(grp); b = myq(path, grp)
print(grp, 'source', len(a), 'mine', len(b))
for n in sorted(set(a) | set(b)):
    if n not in a or n not in b:
        print('MISSING', n, n in a, n in b); continue
    sa, oa = a[n]; sb, ob = b[n]
    sb = clean(sb); ob = [clean(o) for o in ob]
    sa_cut = re.sub(r'\s*(T\d+ .*|vatímetro directa.*)$', '', sa)
    if sa_cut != sb and sa != sb:
        print(n, 'STEM\n  S:', sa, '\n  M:', sb)
    for i,(x,y) in enumerate(zip(oa, ob)):
        x2 = re.sub(r'\s*(T\d+(\.\d+)? .*|\d{3}|T\d+ [A-Z].*)$', '', x)
        if x2 != y:
            print(n, 'OPT', 'abcd'[i], '\n  S:', x, '\n  M:', y)
    if len(oa) != len(ob): print(n, 'NOPTS', len(oa), len(ob))
