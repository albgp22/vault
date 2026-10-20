# Replace the text between a start marker (inclusive) and an end marker (exclusive).
import sys, runpy
p = '/Users/albertogarciaplanes/tmpradio/cheatsheet.typ'
s = open(p, encoding='utf-8').read()
blocks = runpy.run_path(sys.argv[1])['BLOCKS']
for a, b, new in blocks:
    i = s.find(a); j = s.find(b, i + 1)
    if i < 0 or j < 0 or s.count(a) != 1:
        print('FAIL', a[:60]); sys.exit(1)
    s = s[:i] + new + s[j:]
open(p, 'w', encoding='utf-8').write(s)
print('OK', len(blocks), 'blocks')
