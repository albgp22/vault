import re, sys, difflib
sys.path.insert(0,'.')
# ---- source (pdftotext) words
P=open('/Users/albertogarciaplanes/tmpradio/source/generated-radio.txt').read().split('\f')
def clean_pages(rng, header_re, start_marker, end_marker):
    txt='\n'.join(P[a-1] for a in rng)
    i=txt.index(start_marker); 
    if end_marker: txt=txt[i:txt.index(end_marker)]
    else: txt=txt[i:]
    return txt
def norm_words(t):
    t=re.sub(r'(?<=[a-záéíóúñü])-\n\s*(?=[a-záéíóúñü])','',t)
    t=re.sub(r'(?<=\d)-\n\s*(?=\d)','-',t)
    t=re.sub(r'(?<=\d)–\n\s*(?=\d)','–',t)
    t=re.sub(r'IE-\n\s*T/','IET/',t)
    return t.split()
# D source
d=clean_pages(range(400,425),None,'Tema R1. Alfabeto','D.21. Refuerzo')
lines=[]
for ln in d.split('\n'):
    s=ln.strip()
    if not s: continue
    if s in ('D Soluciones Razonadas',) or s.startswith('D.20 PReguntas') or re.fullmatch(r'\d{3}',s): continue
    if re.match(r'^(Pregunta|Respuesta)\s',s): continue
    if re.match(r'^(Tema R\d\.|Preguntas heredadas)',s): continue
    lines.append(ln.strip())
src_d=norm_words('\n'.join(lines))
# generated typ -> words
t=open('/Users/albertogarciaplanes/tmpradio/chapters/ap-b2.typ').read()
# keep only sol: contents? simpler: extract sol text by regex per q
qs=re.findall(r'#q\("([^"]+)", "([a-d])",\n  \[(.*?)\],\n  \((.*?)\),\n  sol: \[(.*?)\],\n\)\n',t,flags=re.S)
print(len(qs))
def untyp(s):
    s=re.sub(r'#(vease|no-esta|_apb2-clave)\[','',s)
    s=re.sub(r'#(emph|strong)\[','',s)
    s=s.replace('#super[2]','2')
    s=re.sub(r'\$([^$]*)\$',lambda m:m.group(1),s)
    s=s.replace('\\','')
    s=s.replace(']','')
    return s
gen=[]
for id_,ans,stem,opts,sol in qs:
    gen.append(id_+' ('+ans+') '+untyp(sol) if not id_.startswith('C-H') else id_+' '+untyp(sol))
gen_words=' '.join(gen).split()
# src words: C-R8.1 (a) ... ; for C-H: "C-H.1 Clave ..."
sm=difflib.SequenceMatcher(None,src_d,gen_words,autojunk=False)
n=0
for tag,i1,i2,j1,j2 in sm.get_opcodes():
    if tag!='equal':
        n+=1
        print(tag,'SRC:',' '.join(src_d[max(0,i1-3):i2+3]),'|| GEN:',' '.join(gen_words[max(0,j1-3):j2+3]))
print('diffs',n,len(src_d),len(gen_words))
