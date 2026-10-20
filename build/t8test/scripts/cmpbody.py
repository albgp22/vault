import re, sys
src = open('/Users/albertogarciaplanes/tmpradio/source/generated-radio.txt').read().split('\f')
rng = {'T8': range(112,118), 'T9': range(118,122), 'T10': range(122,130)}
grp, path = sys.argv[1], sys.argv[2]
txt = '\n'.join(src[i] for i in rng[grp])
# drop questions and options
body = re.sub(r'^%s\.\d+ .*?(?=^\S|\Z)' % grp, '', txt, flags=re.S|re.M)
lines = [l.strip() for l in txt.split('\n')]
def norm(t):
    t = re.sub(r'-\n\s*', '', t)
    t = re.sub(r'[\s ]+', ' ', t)
    return t.strip()
mine = open(path).read()
mine = re.sub(r'[*_]', '', mine)
mine = mine.replace('\\', '')
mine = norm(mine)
# take source paragraphs: lines starting with 3 spaces indentation begin paragraphs
paras = re.split(r'\n\s*\n|\n(?=   \S)', txt)
miss = 0
for p in paras:
    p = norm(p)
    if len(p) < 120 or re.match(r'^(%s\.\d+|[a-d]\))' % grp, p): continue
    # check sliding chunks
    words = p.split(' ')
    for i in range(0, len(words)-8, 8):
        chunk = ' '.join(words[i:i+8])
        if re.search(r'[𝐴-𝜔]|\d\s*$', chunk): continue
        if chunk not in mine:
            print('NOT FOUND:', chunk); miss += 1
print(grp, 'missing chunks:', miss)
