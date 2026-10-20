import re, unicodedata
src = open('/Users/albertogarciaplanes/tmpradio/source/generated-radio.txt').read().split('\f')
mine = open('/Users/albertogarciaplanes/tmpradio/chapters/t02.typ').read()
def norm(s):
    s = unicodedata.normalize('NFKC', s)
    s = re.sub(r'[\$\*_\\«»"]', '', s)
    s = re.sub(r'-\n\s*', '', s)
    s = re.sub(r'[^\w%,.;:()=+/]', '', s.lower())
    return s
nm = norm(mine)
for pg in range(48, 61):
    lines = src[pg].split('\n')
    # drop header/footer lines
    body = '\n'.join(l for l in lines if not re.match(r'^\s*(T2 Componentes|T2\.\d [A-ZÁÉÍÓÚa-záéíóúR ]+|\d+)\s*$', l))
    ns = norm(body)
    W = 30
    miss = []
    k = 0
    while k < len(ns) - W:
        w = ns[k:k+W]
        if w not in nm:
            miss.append(w); k += W
        else:
            k += 10
    print('PAGE', pg+1, 'missing windows:', len(miss))
    for w in miss: print('   ', w)
