import re, json, sys
sys.path.insert(0,'/Users/albertogarciaplanes/tmpradio/build/r1r5')
from gen import *
PQ=load('/Users/albertogarciaplanes/tmpradio/build/r1r5/xml/r.xml')
PS=load('/Users/albertogarciaplanes/tmpradio/build/r1r5/xml/d.xml')
ID=re.compile(r'^R[1-5]\.\d+$')
OPT=re.compile(r'^([a-d])\)$')
hyph=[]
def join(a,b):
    if a.endswith('-') and b and b[0].islower() and not a.endswith(' -'):
        hyph.append((a[-12:],b[:12]))
        return a[:-1]+b
    return a+' '+b

questions={}
order=[]
cur=None; curopt=None; lastpage=None; lasttop=None
for n in range(133,171):
    for l in PQ[n]:
        top=l['top']
        if top<100 or top>1150: continue
        els=l['els']; first=els[0]['plain'].strip()
        if ID.match(first):
            cur=dict(id=first,stem=render(els[1:]),opts=[],page=n); questions[first]=cur; order.append(first); curopt=None
            lastpage=n; lasttop=top; continue
        m=OPT.match(first)
        if cur is not None and m and lastpage==n:
            curopt=[m.group(1),render(els[1:])]; cur['opts'].append(curopt); lasttop=top; continue
        if cur is not None and lastpage==n and top-lasttop<=24:
            t=render(els)
            if curopt is None: cur['stem']=join(cur['stem'],t)
            else: curopt[1]=join(curopt[1],t)
            lasttop=top; continue
        cur=None; curopt=None
        lastpage=n; lasttop=top

sols={}
cur=None; lastpage=None; lasttop=None
for n in range(353,363):
    for l in PS[n]:
        top=l['top']
        if top<100 or top>1150: continue
        els=l['els']; first=els[0]['plain'].strip()
        if re.match(r'^D\.16',first): cur=None; break
        if ID.match(first) and len(els)>1 and re.match(r'^\([a-d]\)$',els[1]['plain'].strip()):
            cur=dict(id=first,ans=els[1]['plain'].strip()[1],text=render(els[2:])); sols[first]=cur
            lastpage=n; lasttop=top; continue
        if cur is not None and lastpage==n and top-lasttop<=24:
            cur['text']=join(cur['text'],render(els)); lasttop=top; continue
        cur=None; lastpage=n; lasttop=top

out={}
for qid in order:
    q=questions[qid]
    s=sols.get(qid)
    out[qid]=dict(stem=q['stem'],opts=q['opts'],ans=s['ans'] if s else None,sol=s['text'] if s else None)
json.dump(out,open('/Users/albertogarciaplanes/tmpradio/build/r1r5/qs.json','w'),ensure_ascii=False,indent=1)
print(len(out),'questions;',len(sols),'solutions')
from collections import Counter
print(Counter(k.rsplit('.',1)[0] for k in out))
bad=[k for k,v in out.items() if len(v['opts'])!=4 or v['ans'] is None or v['sol'] is None]
print('bad',bad)
print('hyph joins:',len(hyph))
for a,b in hyph: print(repr(a),'|',repr(b))
extra=[k for k in sols if k not in out]
print('sols without question',extra)
