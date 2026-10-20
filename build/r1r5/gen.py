import re, json, sys
import xml.etree.ElementTree as ET

def kind(fam):
    if 'Inconsolata' in fam: return 'm'
    if 'LinLibertineOB' in fam: return 'b'
    if 'LinLibertineOI' in fam: return 'i'
    if 'Biolinum' in fam: return 's'
    return 'n'

def runs(el, base):
    out=[]
    if el.text: out.append((base, el.text))
    for ch in el:
        sub = base
        if ch.tag=='b' and base=='n': sub='b'
        if ch.tag=='i' and base=='n': sub='i'
        out.extend(runs(ch, sub))
        if ch.tail: out.append((base, ch.tail))
    return out

def load(path):
    root=ET.parse(path).getroot()
    fonts={f.get('id'):kind(f.get('family')) for f in root.iter('fontspec')}
    pages={}
    for page in root.findall('page'):
        n=int(page.get('number'))
        els=[]
        for t in page.findall('text'):
            base=fonts.get(t.get('font'),'n')
            rs=runs(t,base)
            els.append(dict(top=int(t.get('top')),left=int(t.get('left')),width=int(t.get('width')),rs=rs,base=base,
                            plain=''.join(x[1] for x in rs)))
        els.sort(key=lambda e:(e['top'],e['left']))
        lines=[]
        for e in els:
            if lines and abs(e['top']-lines[-1]['top'])<=5:
                lines[-1]['els'].append(e)
            else:
                lines.append(dict(top=e['top'],els=[e]))
        for l in lines: l['els'].sort(key=lambda e:e['left'])
        pages[n]=lines
    return pages

def el_markup(e):
    txt=''
    for k,tx in e['rs']:
        s=tx.strip()
        if not s: txt+=tx; continue
        lead=tx[:len(tx)-len(tx.lstrip())]; trail=tx[len(tx.rstrip()):]
        if k=='m': txt+=lead+'`'+s+'`'+trail
        elif k=='b': txt+=lead+'*'+s+'*'+trail
        elif k=='i': txt+=lead+'_'+s+'_'+trail
        else: txt+=tx
    return txt.strip()

def render(els):
    out=''
    for i,e in enumerate(els):
        core=el_markup(e)
        if i>0:
            gap=e['left']-(els[i-1]['left']+els[i-1]['width'])
            if gap>=2: out+=' '
        out+=core
    return out
