import re, json
B='/Users/albertogarciaplanes/tmpradio/build/r6to9/'
d=json.load(open(B+'lines.json'))
def hyph_join(parts):
    out=''
    for p in parts:
        p=p.strip()
        if not p: continue
        if out.endswith('-') and not re.search(r'[\d ]-$',out):
            out=out[:-1]+p
        else:
            out=(out+' '+p) if out else p
    return out
def parse_sol():
    lines=[]
    for i,ls in d['sol']:
        lines+=ls
    # cut between D.16 heading and D.20 heading
    start=next(k for k,l in enumerate(lines) if re.match(r'^D\.16\.\s+Tema R6',l))
    end=next(k for k,l in enumerate(lines) if re.match(r'^D\.20\.',l))
    lines=lines[start:end]
    keys={}
    entries={}
    cur=None
    group=None
    tabl={}
    for l in lines:
        if not l.strip():
            continue
        mg=re.match(r'^D\.(\d+)\.\s+Tema (R\d)\.',l)
        if mg:
            cur=None; group=mg.group(2); tabl.setdefault(group,{'q':[],'a':[]}); continue
        m=re.match(r'^\s*Pregunta\s+(.*)$',l)
        if m:
            tabl[group]['q']+= [int(x) for x in m.group(1).split()]; continue
        m=re.match(r'^\s*Respuesta\s+(.*)$',l)
        if m:
            tabl[group]['a']+= m.group(1).split(); continue
        m=re.match(r'^(R\d\.\d+) \(([a-d])\)\s+(.*)$',l)
        if m:
            cur=m.group(1); entries[cur]={'ans':m.group(2),'parts':[m.group(3)]}; continue
        if cur is not None:
            entries[cur]['parts'].append(l.strip()); continue
        print('UNPARSED',repr(l))
    for k,e in entries.items():
        e['text']=hyph_join(e['parts'])
    return entries,tabl
if __name__=='__main__':
    entries,tabl=parse_sol()
    print(len(entries))
    for g,t in tabl.items():
        print(g,len(t['q']),len(t['a']))
    # cross-check key table vs entries
    bad=0
    for g,t in tabl.items():
        for n,a in zip(t['q'],t['a']):
            id=f'{g}.{n}'
            if entries[id]['ans']!=a:
                print('MISMATCH',id,entries[id]['ans'],a); bad+=1
    print('mismatches',bad)
