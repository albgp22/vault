import re, sys, difflib
P=open('/Users/albertogarciaplanes/tmpradio/source/generated-radio.txt').read().split('\f')
txt='\n'.join(P[a-1] for a in range(244,264))
i=txt.index('B.11.     Tema R1'); txt=txt[i:]
lines=[]
for ln in txt.split('\n'):
    s=ln.strip()
    if not s: continue
    if s.startswith('B PReguntas') or re.match(r'^B\.\d+ Tema',s) or re.match(r'^B\.\d+ PReg',s) or re.fullmatch(r'\d{3}',s): continue
    if re.match(r'^B\.\d+\.\s+(Tema|Preguntas)',s): continue
    # option label removal
    s=re.sub(r'^[abcd]\)\s+','',s)
    lines.append(s)
t='\n'.join(lines)
t=re.sub(r'(?<=[a-záéíóúñü])-\n(?=[a-záéíóúñü])','',t)
t=t.replace('IE-\nT/','IET/')
src=t.split()
g=open('/Users/albertogarciaplanes/tmpradio/chapters/ap-b2.typ').read()
qs=re.findall(r'#q\("([^"]+)", "([a-d])",\n  \[(.*?)\],\n  \((.*?)\),\n  sol: \[(.*?)\],\n\)\n',g,flags=re.S)
gen=[]
def untyp(s):
    s=re.sub(r'#(emph|strong)\[','',s); s=s.replace(']','').replace('\\','')
    return s
for id_,ans,stem,opts,sol in qs:
    gen.append(id_+' '+untyp(stem))
    o=re.split(r'\], \[',opts.strip()[1:-1])
    gen+= [untyp(x) for x in o]
# ojo text
m=re.search(r'#ojo\[(.*?)\]\n',g,flags=re.S)
gw=' '.join(gen).split()
# insert ojo words at B.19 place for comparison: skip (compare ignoring)
sm=difflib.SequenceMatcher(None,src,gw,autojunk=False)
for tag,i1,i2,j1,j2 in sm.get_opcodes():
    if tag!='equal': print(tag,'SRC:',' '.join(src[max(0,i1-3):i2+3]),'|| GEN:',' '.join(gw[max(0,j1-3):j2+3]))
print(len(src),len(gw))
