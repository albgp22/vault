import re, sys
src = open('/Users/albertogarciaplanes/tmpradio/source/generated-radio.txt').read().split('\f')
txt = '\n'.join(src[346:353])
lines = [l for l in txt.split('\n') if not re.match(r'^\s*\d{3}\s*$', l) and not re.match(r'^\s*(D Soluciones Razonadas|D\.\d+ Tema .*)\s*$', l)]
txt = '\n'.join(lines)
def norm(t):
    t = re.sub(r'-\n\s*', '', t)
    t = re.sub(r'\s+', ' ', t).strip()
    return t
grp, path = sys.argv[1], sys.argv[2]
a = {}
for m in re.finditer(r'^%s\.(\d+) \(([a-d])\) (.*?)(?=^T\d+\.\d+ \([a-d]\) |^D\.\d+\. |^R1\.1 |\Z)' % grp, txt, re.S | re.M):
    a[int(m.group(1))] = (m.group(2), norm(m.group(3)))
s = open(path).read()
b = {}
for m in re.finditer(r'#q\("%s\.(\d+)", "([a-d])",.*?\n  sol: \[(.*?)\],\n\)' % grp, s, re.S):
    b[int(m.group(1))] = (m.group(2), norm(m.group(3)))
def clean(t):
    t = re.sub(r'_([^_]*)_', r'\1', t)
    t = t.replace('$', '').replace('\\', '').replace('#sub[2]', '2')
    return t
print(grp, len(a), len(b))
for n in sorted(set(a)|set(b)):
    if n not in a or n not in b: print('MISSING', n); continue
    if a[n][0] != b[n][0]: print(n, 'ANS', a[n][0], b[n][0])
    x, y = a[n][1], clean(b[n][1])
    if x != y: print(n, '\n  S:', x, '\n  M:', y)
