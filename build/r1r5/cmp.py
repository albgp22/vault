import re, subprocess, sys
P=open('/Users/albertogarciaplanes/tmpradio/source/generated-radio.txt').read().split('\f')
ranges={'r01':(132,138),'r02':(138,146),'r03':(146,154),'r04':(154,160),'r05':(160,170)}
sol_ranges={'R1':None}
def words(t):
    t=re.sub(r'(?<=[A-Za-zÁÉÍÓÚáéíóúñü])-\s*\n\s*(?=[a-záéíóúñü])','',t)  # dehyphenate
    t=t.replace('­','')
    t=re.sub(r'[«»“”"¿¡?!,.;:()\[\]…—–/·=≈⇒+<>]',' ',t)
    t=t.lower()
    return re.findall(r"[0-9a-záéíóúñü'’\-]+",t)
def shingles(w,n=4):
    return [' '.join(w[i:i+n]) for i in range(len(w)-n+1)]
tot=0
for name,(a,b) in ranges.items():
    k=name[-1]
    src='\n'.join(P[a:b])
    # drop running headers/page numbers: lines like 'R2 CÓdigo Q' / 'R2.1 El cÓdigo...'
    src='\n'.join(l for l in src.split('\n') if not re.match(r'^\s*(R\d [A-Za-zÁÉÍÓÚÑ ]+|R\d\.\d [A-Za-zÁÉÍÓÚÑ ]+|\d+)\s*$',l) or re.match(r'^\s*R\d\.\d+ ',l))
    pdf=subprocess.run(['pdftotext','-layout',f'/Users/albertogarciaplanes/tmpradio/build/{name}.pdf','-'],capture_output=True,text=True).stdout
    sw=words(src); pw=words(pdf)
    ps=set(shingles(pw))
    miss=[s for s in shingles(sw) if s not in ps]
    print(name,'src words',len(sw),'pdf words',len(pw),'missing shingles',len(miss))
    # group consecutive misses
    out=[];prev=-9
    sh=shingles(sw)
    idx=[i for i,s in enumerate(sh) if s not in ps]
    groups=[];cur=[]
    for i in idx:
        if cur and i-cur[-1]>1: groups.append(cur);cur=[]
        cur.append(i)
    if cur: groups.append(cur)
    for g in groups[:25]:
        print('   ...',' '.join(sw[max(0,g[0]-1):g[-1]+5]))
