#!/usr/bin/env python3
# Stage 1: pdftohtml XML -> paragraphs with style markers.
import re, sys, xml.etree.ElementTree as ET, json
S = '/Users/albertogarciaplanes/tmpradio/build/apb1/'

# sentinels
I0, I1 = '', ''   # italic
B0, B1 = '', ''   # bold
U0, U1 = '', ''   # superscript
D0, D1 = '', ''   # subscript


def load(path):
    t = open(path, encoding='utf-8').read()
    t = t.split('<!DOCTYPE pdf2xml SYSTEM "pdf2xml.dtd">')[-1].strip()
    root = ET.fromstring(t)
    pages = []
    fonts = {}
    for p in root.findall('page'):
        for f in p.findall('fontspec'):
            fonts[f.get('id')] = dict(size=int(f.get('size')), family=f.get('family').split('+')[-1], color=f.get('color'))
        items = []
        for e in p.findall('text'):
            runs = []
            def walk(n, i, b):
                if n.tag == 'i': i = True
                if n.tag == 'b': b = True
                if n.text:
                    runs.append((n.text, i, b))
                for c in n:
                    walk(c, i, b)
                    if c.tail:
                        runs.append((c.tail, i, b))
            walk(e, False, False)
            top = int(e.get('top')); left = int(e.get('left')); w = int(e.get('width')); h = int(e.get('height'))
            f = fonts[e.get('font')]
            items.append(dict(top=top, left=left, width=w, height=h, size=f['size'], family=f['family'], color=f['color'], runs=runs))
        pages.append((int(p.get('number')), items))
    return pages


def is_script(it, main_size):
    return it['size'] <= 11 and main_size >= 13


def build_lines(items, ymin=90, ymax=1170):
    items = [it for it in items if ymin <= it['top'] <= ymax]
    if not items:
        return []
    # main elements: size >= 12
    mains = [it for it in items if it['size'] >= 12]
    mains.sort(key=lambda it: (it['top'] + it['height'] / 2, it['left']))
    # cluster main items into lines by center
    lines = []
    for it in mains:
        c = it['top'] + it['height'] / 2
        placed = False
        for ln in lines:
            if abs(ln['c'] - c) <= 8:
                ln['items'].append(it)
                ln['c'] = sum(x['top'] + x['height'] / 2 for x in ln['items']) / len(ln['items'])
                placed = True
                break
        if not placed:
            lines.append(dict(c=c, items=[it]))
    lines.sort(key=lambda l: l['c'])
    scripts = [it for it in items if it['size'] < 12]
    for it in scripts:
        c = it['top'] + it['height'] / 2
        best = min(lines, key=lambda l: abs(l['c'] - c))
        best['items'].append(it)
        it['script'] = True
    return lines


def line_text(ln):
    its = sorted(ln['items'], key=lambda it: it['left'])
    main_c = [it['top'] + it['height'] / 2 for it in its if not it.get('script') and it['size'] >= 13]
    main_size = max(it['size'] for it in its if not it.get('script'))
    # reference center: median of main items' centers
    main_c.sort()
    ref = main_c[len(main_c) // 2] if main_c else ln['c']
    out = ''
    prev_right = None
    for it in its:
        txt = ''
        for t, i, b in it['runs']:
            t = t.replace('\xa0', ' ')
            if not t:
                continue
            seg = t
            if i: seg = I0 + seg + I1
            if b: seg = B0 + seg + B1
            txt += seg
        if it.get('script'):
            c = it['top'] + it['height'] / 2
            d = c - ref
            # sup if clearly above; sub if below
            kind = 'U' if d < 1.0 else 'D'
            # (calibrated below)
            txt = (U0 + txt + U1) if kind == 'U' else (D0 + txt + D1)
        # space between items: gap
        if prev_right is not None:
            gap = it['left'] - prev_right
            if gap > 1.8 and not it.get('script') and not (out.endswith(' ') or txt.startswith(' ')):
                out += ' '
        out += txt
        prev_right = it['left'] + it['width']
    return out, ref


if __name__ == '__main__':
    which = sys.argv[1]
    pg = int(sys.argv[2])
    pages = load(S + ('sol.xml' if which == 's' else 'q.xml'))
    for n, items in pages:
        if n != pg: continue
        for ln in build_lines(items):
            t, ref = line_text(ln)
            print(f"{ln['c']:.0f}  {t}")
