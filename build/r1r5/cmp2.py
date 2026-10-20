import re, subprocess
P=open('/Users/albertogarciaplanes/tmpradio/source/generated-radio.txt').read().split('\f')
ranges={'r01':(132,138),'r02':(138,146),'r03':(146,154),'r04':(154,160),'r05':(160,170)}
def nz(s): return re.sub(r'[^0-9a-záéíóúñü]','',s.lower())
for name,(a,b) in ranges.items():
    pdf=subprocess.run(['pdftotext','-raw',f'/Users/albertogarciaplanes/tmpradio/build/{name}.pdf','-'],capture_output=True,text=True).stdout
    pn=nz(pdf)
    src='\n'.join(P[a:b])
    # split into blocks by blank lines
    blocks=re.split(r'\n\s*\n',src.replace('\f','\n\n'))
    miss=0
    for bl in blocks:
        lines=[l.strip() for l in bl.split('\n') if l.strip()]
        if not lines: continue
        # drop running header/page numbers
        lines=[l for l in lines if not re.match(r'^(R\d [A-Za-zÁÉÍÓÚÑ ]+|R\d\.\d\.? [A-Za-zÁÉÍÓÚÑ ]+|\d+)$',l) or re.match(r'^R\d\.\d+\.? ',l) and False]
        txt=' '.join(lines)
        if len(nz(txt))<6: continue
        # check each line separately (to localise) 
        bad=[l for l in lines if len(nz(l))>=8 and nz(l).rstrip() not in pn]
        # lines may break mid-word w/ hyphen: test line pair joined
        if bad:
            # try whole block
            if nz(txt) in pn: continue
            miss+=1
            print(name,'| BLOCK MISS:',txt[:200])
    print(name,'blocks missing:',miss)
