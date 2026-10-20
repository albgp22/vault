"""Compara, por grupo, las preguntas del PDF original con las llamadas #q(...) de chapters/.
Uso: python3 -I tools/verify-questions.py"""
import re, glob, collections, os
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
pages = open(os.path.join(ROOT, 'source/generated-radio.txt')).read().split('\f')
idre = re.compile(r'^\s{0,4}((?:[A-Z]-)?[A-Z]+\d*\.\d+)\s', re.M)
def ids(a, b):
    out = []
    for p in range(a, b + 1):
        out += idre.findall(pages[p - 1])
    return out
def grp(i): return i.rsplit('.', 1)[0]
src_q = collections.OrderedDict()
for i in ids(37, 328):
    src_q.setdefault(grp(i), []).append(i)
src_s = collections.OrderedDict()
for i in ids(329, 488):
    src_s.setdefault(grp(i), []).append(i)
typ = collections.OrderedDict()
ans = collections.Counter()
for f in sorted(glob.glob(os.path.join(ROOT, 'chapters/*.typ'))):
    t = open(f).read()
    for m in re.finditer(r'#q\(\s*"([^"]+)"\s*,\s*"([^"]*)"', t):
        typ.setdefault(grp(m.group(1)), []).append(m.group(1))
        if not m.group(2).strip(): ans[grp(m.group(1))] += 1
groups = list(dict.fromkeys(list(src_q) + list(src_s) + list(typ)))
bad = 0
print(f'{"grupo":8} {"orig":>5} {"sol":>5} {"typst":>6}  estado')
for g in groups:
    a = len(set(src_q.get(g, []))); s = len(set(src_s.get(g, []))); t = len(typ.get(g, []))
    dup = len(typ.get(g, [])) - len(set(typ.get(g, [])))
    st = 'ok' if t and t == max(a, s) and not dup else ('FALTA' if t == 0 else 'REVISAR')
    if st != 'ok': bad += 1
    extra = f' dup={dup}' if dup else ''
    extra += f' sin-letra={ans[g]}' if ans[g] else ''
    if t and t != max(a, s):
        missing = sorted(set(src_q.get(g, [])) | set(src_s.get(g, [])) - set(typ.get(g, [])), key=lambda x: int(x.rsplit('.',1)[1]))
        missing = [m for m in missing if m not in set(typ.get(g, []))]
        extra += f' faltan={missing[:12]}'
    print(f'{g:8} {a:5} {s:5} {t:6}  {st}{extra}')
print('grupos con problemas:', bad)
