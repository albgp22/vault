import re, subprocess, difflib, sys
sys.path.insert(0,'.')
ROOT='/Users/albertogarciaplanes/tmpradio'
p=open(ROOT+'/source/generated-radio.txt').read().split('\f')
HDR=[re.compile(r'^\s*C RefueRzo del temaRio\s*$'),re.compile(r'^\s+C\.\d+ .*$'),re.compile(r'^\s*\d{3}\s*$')]
lines=[]
for pg in p[285:306]:
    for l in pg.split('\n'):
        if any(h.match(l) for h in HDR): continue
        lines.append(l)
s=next(i for i,l in enumerate(lines) if re.match(r'^C\.4\.\s+Tema T4',l))
e=next(i for i,l in enumerate(lines) if re.match(r'^C\.16\.\s+Tema R8',l))
src='\n'.join(lines[s:e])
src=re.sub(r'^C\.\d+\.\s+Tema.*$','',src,flags=re.M)
src=src.replace('𝜇','μ').replace('𝑄','Q')
src=re.sub(r'([a-záéíóúñü])-\n\s*([a-záéíóúñü])',r'\1\2',src)
out=subprocess.run(['pdftotext','-f','1','-l','18','-layout',ROOT+'/build/ap-c2.pdf','-'],capture_output=True,text=True).stdout
out=re.sub(r'^\s*\d+\s*$','',out,flags=re.M)
out=re.sub(r'^\s*\d+\.\s+Tema.*$','',out,flags=re.M)
out=re.sub(r'([a-záéíóúñü])-\n\s*([a-záéíóúñü])',r'\1\2',out)
def toks(t):
    t=re.sub(r'\s+',' ',t)
    return t.split(' ')
a=toks(src); b=toks(out)
a=[x for x in a if x]; b=[x for x in b if x]
sm=difflib.SequenceMatcher(None,a,b,autojunk=False)
n=0
for tag,i1,i2,j1,j2 in sm.get_opcodes():
    if tag!='equal':
        n+=1
        print(tag,'SRC:',' '.join(a[max(i1-2,0):i2+2]),'|| OUT:',' '.join(b[max(j1-2,0):j2+2]))
print('diffs',n,'src tokens',len(a),'out tokens',len(b))
