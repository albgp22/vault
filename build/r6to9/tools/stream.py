import re, json
B='/Users/albertogarciaplanes/tmpradio/build/r6to9/'
d=json.load(open(B+'lines.json'))
ranges={'R6':(171,174),'R7':(175,177),'R8':(179,192),'R9':(193,197)}
def join_lines(parts):
    out=''
    for p in parts:
        p=p.strip()
        if not p: continue
        if out.endswith('-') and not out.endswith(' -') and not re.search(r'\d-$',out):
            out=out[:-1]+p
        else:
            out=(out+' '+p) if out else p
    return out
def parse_tema(key):
    a,b=ranges[key]
    lines=[]
    for i,ls in d['src']:
        if a<=i<=b: lines+=ls
    items=[]
    cur=None
    prose=[]
    def flush_prose():
        nonlocal prose
        if prose:
            items.append(('prose',prose)); prose=[]
    def close_q():
        nonlocal cur
        if cur:
            items.append(('q',cur)); cur=None
    for l in lines:
        if not l.strip():
            continue
        mh=re.match(r'^(R\d\.\d+)\.\s{2,}(\S.*)$',l)
        mq=re.match(r'^(R\d\.\d+)\s+(\S.*)$',l)
        mo=re.match(r'^\s+([a-d])\)\s+(\S.*)$',l)
        if mh:
            close_q(); flush_prose(); items.append(('h',mh.group(1),mh.group(2).strip())); continue
        if mq and mq.group(1).startswith(key+'.') and not mo:
            close_q(); flush_prose()
            cur={'id':mq.group(1),'stem':[mq.group(2)],'opts':[]}
            continue
        if cur is not None:
            if mo and mo.group(1)==chr(ord('a')+len(cur['opts'])):
                cur['opts'].append([mo.group(2)]); continue
            if cur['opts']:
                if len(l)-len(l.lstrip())>=5:
                    cur['opts'][-1].append(l.strip()); continue
                else:
                    close_q(); prose.append(l); continue
            else:
                cur['stem'].append(l.strip()); continue
        prose.append(l)
    close_q(); flush_prose()
    return items
if __name__=='__main__':
    for k in ranges:
        items=parse_tema(k)
        nq=sum(1 for it in items if it[0]=='q')
        print('#####',k,'questions',nq)
        for it in items:
            if it[0]=='q':
                q=it[1]
                ok=len(q['opts'])==4
                print(q['id'], 'OPTS',len(q['opts']), ('' if ok else '!!!'))
            elif it[0]=='h': print('HEAD',it[1:])
            else: print('PROSE',len(it[1]),'lines:',it[1][0][:60])
