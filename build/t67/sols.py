import re, sys, unicodedata
src = open('/Users/albertogarciaplanes/tmpradio/source/generated-radio.txt').read().split('\f')
a, b, f, pre = int(sys.argv[1]), int(sys.argv[2]), sys.argv[3], sys.argv[4]
txt = '\n'.join(src[a-1:b])
txt = re.sub(r'\n\s*\d{3}\s*\n', '\n', txt)
typ = open(f).read()
def norm(s):
    s = unicodedata.normalize('NFKC', s)
    return re.sub(r'[^a-záéíóúñü0-9]', '', s.lower())
# my answers
mine = dict(re.findall(r'#q\("' + re.escape(pre) + r'\.(\d+)", "([a-d])"', typ))
T = norm(typ)
ents = re.findall(r'(?:^|\n)\s*' + re.escape(pre) + r'\.(\d+) \(([a-d])\) (.*?)(?=\n\s*(?:' + re.escape(pre) + r'\.\d+ \([a-d]\)|D\.\d|\Z))', txt, re.S)
seen=set()
for num, l, body in ents:
    if num in seen: continue
    seen.add(num)
    if mine.get(num) != l: print('ANS MISMATCH', num, l, mine.get(num))
    n = norm(re.sub(r'\s+', ' ', re.sub(r'-\n', '', body)))
    ch = [n[i:i+16] for i in range(0, max(1,len(n)-16), 16)]
    fr = sum(c in T for c in ch)/len(ch)
    if fr < 0.85: print('SOL?', num, round(fr,2), body[:120].replace('\n',' '))
print('entries', len(seen), 'mine', len(mine))
