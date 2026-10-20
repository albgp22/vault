import re, sys, difflib, subprocess
T='/Users/albertogarciaplanes/tmpradio/build/r6to9/tools'
sys.path.insert(0,T)
from sol import parse_sol
entries,tabl=parse_sol()
files={'R6':'r06','R7':'r07','R8':'r08','R9':'r09'}
for g,f in files.items():
    sw=[]
    for id,e in entries.items():
        if id.startswith(g+'.'):
            sw+= [id,'(%s)'%e['ans']]+e['text'].split()
    txt=subprocess.run(['pdftotext','-raw','/Users/albertogarciaplanes/tmpradio/build/%s.pdf'%f,'-'],capture_output=True,text=True).stdout
    pages=txt.split('\f')
    idx=next(i for i,p in enumerate(pages) if 'Soluciones del grupo' in p)
    t='\n'.join(pages[idx:])
    # drop up to first entry
    start=t.index(g+'.1 (')
    pw=[]
    for l in t[start:].split('\n'):
        l=l.strip()
        if not l: continue
        pw+=l.split()
    # remove soft hyphen splits "pa­ labra" -> join
    out=[]
    for w in pw:
        out.append(w)
    # normalise: join "xxx­" (soft hyphen char U+00AD) with next
    pw2=[];i=0
    while i<len(out):
        w=out[i]
        if w.endswith('­') and i+1<len(out):
            pw2.append(w[:-1]+out[i+1]); i+=2
        else:
            pw2.append(w); i+=1
    sm=difflib.SequenceMatcher(None,sw,pw2,autojunk=False)
    print('#####',g,len(sw),len(pw2))
    for tag,i1,i2,j1,j2 in sm.get_opcodes():
        if tag!='equal':
            print(tag,'SRC:',' '.join(sw[max(0,i1-3):i2+3]),'||PDF:',' '.join(pw2[max(0,j1-3):j2+3]))
