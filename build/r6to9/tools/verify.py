import re, json, subprocess, sys, difflib
B='/Users/albertogarciaplanes/tmpradio/build/r6to9/'
d=json.load(open(B+'lines.json'))
ranges={'R6':(171,174,'r06'),'R7':(175,177,'r07'),'R8':(179,192,'r08'),'R9':(193,197,'r09')}
def words(txt):
    txt=txt.replace('­','')
    return txt.split()
def src_words(key):
    a,b,_=ranges[key]
    lines=[]
    for i,ls in d['src']:
        if a<=i<=b: lines+=[l.strip() for l in ls if l.strip()]
    out=[]
    for l in lines:
        if out and out[-1].endswith('-') and re.match(r'^[a-záéíóúñü]',l):
            out[-1]=out[-1][:-1]+l.split()[0]
            out+=l.split()[1:]
        else:
            out+=l.split()
    return out
def pdf_words(key, part):
    _,_,f=ranges[key]
    txt=subprocess.run(['pdftotext','-raw','/Users/albertogarciaplanes/tmpradio/build/%s.pdf'%f,'-'],capture_output=True,text=True).stdout
    pages=txt.split('\f')
    # find start of solutions page(s)
    idx=next(i for i,p in enumerate(pages) if 'Soluciones del grupo' in p)
    if part=='q':
        t='\n'.join(pages[:idx])
    else:
        t='\n'.join(pages[idx:])
    out=[]
    for l in t.split('\n'):
        l=l.strip()
        if not l: continue
        if out and out[-1].endswith('-') and re.match(r'^[a-záéíóúñü]',l) and False:
            pass
        out+=l.split()
    return out
if __name__=='__main__':
    key=sys.argv[1]
    sw=src_words(key); pw=pdf_words(key,'q')
    sm=difflib.SequenceMatcher(None,sw,pw,autojunk=False)
    for tag,i1,i2,j1,j2 in sm.get_opcodes():
        if tag!='equal':
            print(tag,'SRC:',' '.join(sw[max(0,i1-3):i2+3]),'||PDF:',' '.join(pw[max(0,j1-3):j2+3]))
