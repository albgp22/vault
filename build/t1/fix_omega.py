import sys, re
p = sys.argv[1]
s = open(p, encoding='utf-8').read()
parts = s.split('$')
n = 0
for i in range(1, len(parts), 2):
    seg = parts[i]
    if 'Ω' in seg:
        # replace Ω not already inside a string
        out, inq = [], False
        for ch in seg:
            if ch == '"':
                inq = not inq
                out.append(ch)
            elif ch == 'Ω' and not inq:
                out.append('"Ω"'); n += 1
            else:
                out.append(ch)
        parts[i] = ''.join(out)
open(p, 'w', encoding='utf-8').write('$'.join(parts))
print('replaced', n, 'segments total', len(parts))
