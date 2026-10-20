import re, subprocess, difflib, sys
ROOT='/Users/albertogarciaplanes/tmpradio'
p=open(ROOT+'/source/generated-radio.txt').read().split('\f')
HDR=[re.compile(r'^\s*D Soluciones Razonadas\s*$'),re.compile(r'^\s+D\.\d+ .*$'),re.compile(r'^\s*\d{3}\s*$')]
lines=[]
for pg in p[441:463]:
    for l in pg.split('\n'):
        if any(h.match(l) for h in HDR): continue
        lines.append(l)
s=next(i for i,l in enumerate(lines) if l.strip()=='Tema T4. Receptores')
e=next(i for i,l in enumerate(lines) if l.strip().startswith('Tema R8. Reglamentaci'))
src='\n'.join(lines[s:e])
src=re.sub(r'^\s*(Tema [TR]\d+\..*|Pregunta .*|Respuesta .*)$','',src,flags=re.M)
src=src.replace('𝜇','μ').replace('NO ESTÁ EN EL TEXTO','NO ESTÁ EN EL TEXTO')
src=re.sub(r'([a-záéíóúñü])-\n\s*([a-záéíóúñü])',r'\1\2',src)
out=subprocess.run(['pdftotext','-f','19','-l','45',ROOT+'/build/ap-c2.pdf','-'],capture_output=True,text=True).stdout
out=re.sub(r'^\s*\d+\s*$','',out,flags=re.M)
out=re.sub(r'^(Soluciones del grupo.*|Pregunta.*|Respuesta.*)$','',out,flags=re.M)
out=re.sub(r'[­]','',out)
out=out.replace('no está en el texto','NO ESTÁ EN EL TEXTO').replace('NO ESTÁ EN EL TEXTO','NO ESTÁ EN EL TEXTO')
out=re.sub(r'([a-záéíóúñü])-\n\s*([a-záéíóúñü])',r'\1\2',out)
def toks(t): return [x for x in re.sub(r'\s+',' ',t).split(' ') if x]
a=toks(src); b=toks(out)
# normalize: lowercase NO ESTA marker variants
a=[x.upper() if x in('NO','ESTÁ','EN','EL','TEXTO') else x for x in a]
b=[x.upper() if x in('no','está','en','el','texto') and False else x for x in b]
sm=difflib.SequenceMatcher(None,a,b,autojunk=False)
n=0
for tag,i1,i2,j1,j2 in sm.get_opcodes():
    if tag!='equal':
        n+=1
        print(tag,'SRC:',' '.join(a[max(i1-3,0):i2+3]),'\n   || OUT:',' '.join(b[max(j1-3,0):j2+3]))
print('diffs',n,len(a),len(b))
