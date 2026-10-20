#!/usr/bin/env python3
import re, sys
sys.path.insert(0, '/Users/albertogarciaplanes/tmpradio/build/apb1')
import s1, s2, s3
from s1 import I0, I1, B0, B1

FIG = {'C-T2.21', 'C-T2.22', 'C-T4.15', 'C-T4.16', 'C-T5.31', 'C-T6.19', 'C-T6.21', 'C-T6.22', 'C-T7.13', 'C-T8.12', 'C-T10.8'}
MANUAL_OPTS = {'C-T1.26', 'C-T6.15'}  # options need manual math


def questions():
    lines = s2.get_lines('q.xml')
    qs = []
    cur = None
    started = False
    for n, c, t in lines:
        p = s2.plain(t)
        if re.match(r'^B\.\d+\.\s', p):
            cur = None
            started = True
            if p.startswith('B.11.'):
                break
            continue
        if not started:
            continue
        m = re.match(r'^(C-T\d+\.\d+)\s+(.*)$', p)
        if m and t.lstrip().startswith(B0):
            rest = re.sub(r'^' + B0 + r'C-T\d+\.\d+' + B1 + r'\s*', '', t)
            cur = dict(id=m.group(1), stem=[rest], opts=[], page=n, mode='stem')
            qs.append(cur)
            continue
        if cur is None:
            continue
        if cur['id'] in FIG:
            # only text options "a) ..." for T4.16, T7.13, T8.12
            if cur['id'] in ('C-T4.16', 'C-T7.13', 'C-T8.12'):
                m2 = re.match(r'^([a-d])\) (.*)$', p)
                if m2 and len(cur['opts']) < 4 and m2.group(1) == 'abcd'[len(cur['opts'])]:
                    cur['opts'].append([t[t.index(')') + 1:].lstrip()])
            continue
        m2 = re.match(r'^([a-d])\)\s*(.*)$', p)
        if m2 and m2.group(1) == 'abcd'[len(cur['opts'])]:
            cur['opts'].append([re.sub(r'^[a-d]\)\s*', '', t.lstrip())])
            cur['mode'] = 'opt'
            continue
        if cur['mode'] == 'stem':
            cur['stem'].append(t)
        else:
            cur['opts'][-1].append(t)
    for q in qs:
        q['stem'], _ = s2.join_lines(q['stem'])
        q['opts'] = [s2.join_lines(o)[0] for o in q['opts']]
    return qs


if __name__ == '__main__':
    qs = questions()
    from collections import Counter
    print(Counter(re.match(r'C-T(\d+)', q['id']).group(1) for q in qs))
    for q in qs:
        if q['id'] in FIG or q['id'] in MANUAL_OPTS:
            print('MANUAL', q['id'], len(q['opts']), s3.convert_para(q['stem']))
            continue
        if len(q['opts']) != 4:
            print('BAD OPTS', q['id'], len(q['opts']))
        print(q['id'], s3.convert_para(q['stem']))
        for o in q['opts']:
            print('    -', s3.convert_para(o))
