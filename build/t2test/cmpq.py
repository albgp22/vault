import re, unicodedata
src = open('/Users/albertogarciaplanes/tmpradio/source/generated-radio.txt').read().split('\f')
txt = '\n'.join(src[48:61])
sol = '\n'.join(src[331:335])
mine = open('/Users/albertogarciaplanes/tmpradio/chapters/t02.typ').read()
def norm(s):
    s = unicodedata.normalize('NFKC', s)
    s = re.sub(r'[\$\*_\\]', '', s)
    s = s.replace('slash', '/').replace('dot', '·')
    s = re.sub(r'\s+', '', s).lower()
    return s
# questions in source
qs = re.split(r'\n\s*(T2\.\d+) ', txt)
src_q = {}
for i in range(1, len(qs), 2):
    qid = qs[i]; body = qs[i+1]
    m = re.split(r'\n\s*([a-d])\)', body)
    stem = m[0]
    opts = [m[j+1].strip() for j in range(1, len(m), 2)]
    # trim trailing page junk from last option
    opts = [o.split('\n')[0] for o in opts]
    src_q[qid] = (stem, opts)
# my q calls
my_q = {}
for m in re.finditer(r'#q\("(T2\.\d+)", "([a-d])",\n  \[(.*?)\],\n  \((.*?)\),\n  sol: \[(.*?)\],\n\)', mine, re.S):
    my_q[m.group(1)] = (m.group(2), m.group(3), m.group(4), m.group(5))
print(len(src_q), len(my_q))
# key
keys = {}
for m in re.finditer(r'(T2\.\d+) \(([a-d])\) (.*?)(?=\nT2\.\d+ \(|\nD\.3|\Z)', sol, re.S):
    keys[m.group(1)] = (m.group(2), m.group(3))
print('keys', len(keys))
for qid in src_q:
    if qid not in my_q: print('MISSING', qid); continue
    a, stem, opts, s = my_q[qid]
    if keys[qid][0] != a: print('KEY MISMATCH', qid, a, keys[qid][0])
    ns = norm(src_q[qid][0]); nm = norm(stem)
    if ns != nm: print('STEM', qid, '\n  src:', ns, '\n  me :', nm)
    for o in src_q[qid][1]:
        if o and norm(o) not in norm(opts): print('OPT', qid, repr(o))
    # solution similarity: check 40-char windows
    nsol = norm(keys[qid][1]); nmy = norm(s)
    miss = 0
    for k in range(0, len(nsol)-25, 25):
        if nsol[k:k+25] not in nmy: miss += 1
    if miss: print('SOL', qid, 'windows missing:', miss, '/', len(nsol)//25)
print('=========')
for qid in ['T2.8','T2.9','T2.10','T2.12','T2.15','T2.16','T2.20','T2.25','T2.32','T2.38','T2.41','T2.45','T2.50','T2.52','T2.53','T2.55','T2.57']:
    nsol = norm(keys[qid][1]); nmy = norm(my_q[qid][3])
    for k in range(0, len(nsol)-25, 25):
        if nsol[k:k+25] not in nmy: print(qid, 'SRC:', nsol[k:k+25])
