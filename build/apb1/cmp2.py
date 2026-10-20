import re, sys, subprocess, unicodedata, difflib
sys.path.insert(0,'/Users/albertogarciaplanes/tmpradio/build/apb1')
import s2, s3, s4

L = lambda t: re.sub(r'[^A-Za-zÁÉÍÓÚÜÑáéíóúüñ]', '', unicodedata.normalize('NFKC', t))
def clean_pdf(t):
    for lab in ['noestáeneltexto','clavedelosbancospúblicos','Preguntascomplementarias','TemaTSeguridad','PreguntaRespuesta','Respuesta','Pregunta','Solucionesdelgrupo','TemaTPropagación']:
        t = t.replace(lab,'')
    return t

pdf = subprocess.run(['pdftotext','/Users/albertogarciaplanes/tmpradio/build/ap-b1.pdf','-'],capture_output=True,text=True).stdout
i = pdf.index('Soluciones del grupo C-T1')
qpart, spart = pdf[:i], pdf[i:]
entries,_ = s2.solutions()
bounds = [(m.start(), m.group(1)) for m in re.finditer(r'(C-T\d+\.\d+) \([a-d]\)', spart)]
got = {}
for k,(pos,id_) in enumerate(bounds):
    end = bounds[k+1][0] if k+1 < len(bounds) else len(spart)
    got[id_] = spart[pos:end]
nd = 0
for e in entries:
    src = ' '.join(s2.plain(t) for k,t in e['paras'])
    src = ''.join(s3.demath(c) for c in src)
    a = L(src)
    b = clean_pdf(L(re.sub(r'^C-T\d+\.\d+ \([a-d]\)','',got[e['id']])))
    if a != b:
        sm = difflib.SequenceMatcher(None, a, b, autojunk=False)
        blocks = [(tag, a[i1:i2], b[j1:j2]) for tag,i1,i2,j1,j2 in sm.get_opcodes() if tag != 'equal']
        print(e['id'], blocks[:6])
        nd += 1
print('entries with differences:', nd)
