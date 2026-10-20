#!/usr/bin/env python3
# Stage 2: assemble solution entries and the question entries; convert text to Typst.
import re, sys, json
sys.path.insert(0, '/Users/albertogarciaplanes/tmpradio/build/apb1')
import s1
from s1 import I0, I1, B0, B1, U0, U1, D0, D1

V0, V1 = '', ''  # "Véase" span
MARKERS = ''.join(chr(c) for c in range(0xe000, 0xe00a))


def plain(t):
    return ''.join(c for c in t if c not in MARKERS)


def get_lines(xmlname, ymin=90, ymax=1170):
    pages = s1.load(s1.S + xmlname)
    res = []
    for n, items in pages:
        for ln in s1.build_lines(items, ymin, ymax):
            t, ref = s1.line_text(ln)
            res.append((n, ln['c'], t))
    return res


def join_lines(lines):
    """Join a list of line strings into a paragraph, dehyphenating."""
    out = ''
    joins = []
    for ln in lines:
        ln = ln.strip()
        if not out:
            out = ln
            continue
        p = plain(out)
        if p.endswith('–') and plain(ln)[:1].isdigit():
            out = out + ln
            continue
        if re.search(r'transmisión-$', p) and plain(ln)[:1].islower():
            out = out + ln
            continue
        if re.search(r'[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]-$', p) and plain(ln)[:1].islower():
            # remove trailing hyphen (may be followed by markers)
            m = re.search(r'-([' + MARKERS + r']*)$', out)
            out = out[:m.start()] + m.group(1) + ln
            joins.append((plain(out[:m.start()])[-14:], plain(ln)[:14]))
        else:
            out = out + ' ' + ln
    return out, joins


def solutions():
    lines = get_lines('sol.xml')
    entries = []
    cur = None
    started = False
    intable = False
    allj = []
    for n, c, t in lines:
        p = plain(t)
        if re.match(r'^C-T\d+\.\d+ \(', p):
            started = True
            intable = False
            m = re.match(r'^(C-T\d+\.\d+) \(([a-d])\)\s*(.*)$', p)
            cur = dict(id=m.group(1), ans=m.group(2), paras=[[ 'sol', [ ]]], page=n)
            entries.append(cur)
            # strip the label (bold id and bold (x)) from the marker string
            t2 = re.sub(r'^' + B0 + r'C-T\d+\.\d+' + B1 + r'\s*' + B0 + r'\([a-d]\)' + B1 + r'\s*', '', t)
            assert t2 != t, t[:80]
            cur['paras'][0][1].append(t2)
            continue
        if not started:
            continue
        if re.match(r'^Tema [TR]\d+\.', p) or p.startswith('D.20'):
            intable = True
            if p.startswith('Tema R1'):
                break
            continue
        if intable:
            if p.startswith(('Pregunta', 'Respuesta')):
                continue
            continue
        if p.startswith('NO ESTÁ EN EL TEXTO'):
            t2 = re.sub(r'^' + B0 + 'NO ESTÁ EN EL TEXTO' + B1 + r'\s*', '', t)
            assert t2 != t, t
            cur['paras'].append(['noesta', [t2]])
            continue
        if p.startswith('CLAVE DE LOS BANCOS PÚBLICOS'):
            t2 = re.sub(r'^' + B0 + 'CLAVE DE LOS BANCOS PÚBLICOS' + B1 + r'\s*', '', t)
            assert t2 != t, t
            cur['paras'].append(['clave', [t2]])
            continue
        cur['paras'][-1][1].append(t)
    for e in entries:
        ps = []
        for kind, ls in e['paras']:
            txt, js = join_lines(ls)
            allj += js
            ps.append((kind, txt))
        e['paras'] = ps
    return entries, allj


def keytables():
    """Answer key tables from plain text, for cross-check."""
    lines = get_lines('sol.xml')
    keys = {}
    grp = None
    pend = None
    for n, c, t in lines:
        p = plain(t)
        m = re.match(r'^Tema T(\d+)\.', p)
        if m:
            grp = int(m.group(1))
            keys.setdefault(grp, [])
            continue
        if re.match(r'^Tema R\d+\.', p):
            grp = None
        if grp is None:
            continue
        if p.startswith('Pregunta '):
            pend = p.split()[1:]
        elif p.startswith('Respuesta '):
            ans = p.split()[1:]
            assert len(ans) == len(pend), (grp, pend, ans)
            for a, b in zip(pend, ans):
                keys[grp].append((int(a), b))
    return keys


if __name__ == '__main__':
    entries, joins = solutions()
    print(len(entries))
    keys = keytables()
    bad = 0
    for e in entries:
        g, k = re.match(r'C-T(\d+)\.(\d+)', e['id']).groups()
        d = dict(keys[int(g)])
        if d.get(int(k)) != e['ans']:
            print('MISMATCH', e['id'], e['ans'], d.get(int(k)))
            bad += 1
    print('mismatches', bad)
    from collections import Counter
    print(Counter(re.match(r'C-T(\d+)', e['id']).group(1) for e in entries))
    print(joins)
