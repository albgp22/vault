# Exact string replacements on cheatsheet.typ. Usage: python3 rep.py pairs.py
import sys, runpy
p = '/Users/albertogarciaplanes/tmpradio/cheatsheet.typ'
s = open(p, encoding='utf-8').read()
pairs = runpy.run_path(sys.argv[1])['PAIRS']
for i, (a, b) in enumerate(pairs):
    n = s.count(a)
    if n != 1:
        print(f'FAIL pair {i}: found {n} times: {a[:80]!r}')
        sys.exit(1)
    s = s.replace(a, b)
open(p, 'w', encoding='utf-8').write(s)
print(f'OK {len(pairs)} replacements')
