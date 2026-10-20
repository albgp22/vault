# ap-c2 parser: questions F-T4..F-R7 (pages 286-306) and solutions (pages 442-463) -> parsed_c2.json
import re, json
ROOT='/Users/albertogarciaplanes/tmpradio'
p=open(ROOT+'/source/generated-radio.txt').read().split('\f')

HDR=[re.compile(r'^\s*C RefueRzo del temaRio\s*$'),
     re.compile(r'^\s*D Soluciones Razonadas\s*$'),
     re.compile(r'^\s+(C|D)\.\d+ .*$'),
     re.compile(r'^\s*\d{3}\s*$')]

def clean_lines(pages):
    out=[]
    for pg in pages:
        for ln in pg.split('\n'):
            if any(h.match(ln) for h in HDR): continue
            out.append(ln.rstrip())
    return out

def dehyph(lines):
    res=''
    for l in lines:
        l=l.strip()
        if not l: continue
        if res.endswith('-') and re.search(r'[a-záéíóúñü]-$',res) and l[0].islower():
            res=res[:-1]+l
        elif res=='': res=l
        else: res+=' '+l
    return res

qlines=clean_lines(p[285:306])
s=next(i for i,l in enumerate(qlines) if re.match(r'^C\.4\.\s+Tema T4',l))
e=next(i for i,l in enumerate(qlines) if re.match(r'^C\.16\.\s+Tema R8',l))
qlines=qlines[s:e]
sections=[]; cur=None; curq=None
def flush_q():
    global curq
    if curq is not None:
        cur[1].append(curq); curq=None
for l in qlines:
    m=re.match(r'^C\.(\d+)\.\s+(Tema .*)$',l)
    if m:
        flush_q(); cur=(m.group(2).strip(),[]); sections.append(cur); continue
    if not l.strip(): continue
    m=re.match(r'^(F-[TR]\d+\.\d+)\s+(.*)$',l)
    if m:
        flush_q(); curq={'id':m.group(1),'stem':[m.group(2)],'opts':[]}; continue
    m=re.match(r'^\s+([a-d])\)\s+(.*)$',l)
    if m:
        curq['opts'].append([m.group(2)]); continue
    if curq is None: raise Exception('stray '+l)
    if curq['opts']: curq['opts'][-1].append(l)
    else: curq['stem'].append(l)
flush_q()
for sec in sections:
    for q in sec[1]:
        q['stem']=dehyph(q['stem']); q['opts']=[dehyph(o) for o in q['opts']]

slines=clean_lines(p[441:463])
s=next(i for i,l in enumerate(slines) if l.strip()=='Tema T4. Receptores')
e=next(i for i,l in enumerate(slines) if l.strip().startswith('Tema R8. Reglamentaci'))
slines=slines[s:e]
keys={}; grp=None; pend=None; body=[]
for l in slines:
    st=l.strip()
    m=re.match(r'^Tema ([TR]\d+)\.',st)
    if m: grp='F-'+m.group(1); continue
    m=re.match(r'^Pregunta\s+(.*)$',st)
    if m: pend=m.group(1).split(); continue
    m=re.match(r'^Respuesta\s+(.*)$',st)
    if m: keys.setdefault(grp,{}).update(dict(zip(pend,m.group(1).split()))); continue
    body.append(l)
items=[]; cur=None
for l in body:
    m=re.match(r'^(F-[TR]\d+\.\d+) \(([a-d])\)\s*(.*)$',l)
    if m:
        cur={'id':m.group(1),'ans':m.group(2),'paras':[[m.group(3)]]}; items.append(cur); continue
    m=re.match(r'^NO ESTÁ EN EL TEXTO\s*(.*)$',l)
    if m:
        cur['paras'].append(['@@NOEST@@',m.group(1)]); continue
    if not l.strip(): continue
    cur['paras'][-1].append(l)
sols={}
for it in items:
    ps=[]
    for pl in it['paras']:
        noest = pl[0]=='@@NOEST@@'
        lines = pl[1:] if noest else pl
        ps.append([noest,dehyph(lines)])
    sols[it['id']]={'ans':it['ans'],'paras':ps}
json.dump({'sections':sections,'sols':sols,'keys':keys},open(ROOT+'/build/ap-c2/parsed_c2.json','w'),ensure_ascii=False,indent=1)
tot=0
for h,qs in sections:
    print(h,len(qs)); tot+=len(qs)
bad=0
for h,qs in sections:
    for q in qs:
        g,n=q['id'].rsplit('.',1)
        if q['id'] not in sols: print('missing sol',q['id']); bad+=1; continue
        if sols[q['id']]['ans']!=keys[g].get(n): print('MISMATCH',q['id']); bad+=1
        if len(q['opts'])!=4: print('opts',q['id'],len(q['opts'])); bad+=1
print('total',tot,'sols',len(sols),'bad',bad)
