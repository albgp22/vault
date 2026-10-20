import re, sys
T='/Users/albertogarciaplanes/tmpradio/build/r6to9/tools'
sys.path.insert(0,T)
from stream import parse_tema, join_lines
from sol import parse_sol

ROOT='/Users/albertogarciaplanes/tmpradio/'

def esc(s):
    out=''
    for ch in s:
        if ch in '\\#$@<>*_[]~`':
            out+='\\'+ch
        else:
            out+=ch
    assert '//' not in s, s
    return out

STEM_OV = {
  'R6.17': [('desde las que no se podía', 'desde las que _no_ se podía')],
  'R8.58': [('la opción incorrecta:', 'la opción _incorrecta_:')],
  'R9.24': [('De las siguientes, no es causa', 'De las siguientes, _no_ es causa')],
}
SOL_OV = {
  'R6.6':  [('(QSY)', '(#_r6-cod[QSY])')],
  'R7.1':  [('«¿QRL?»', '«#_r7-cod[¿QRL?]»')],
  'R7.10': [('instrucción individual, intercomunicación y estudios técnicos', '_instrucción individual, intercomunicación y estudios técnicos_')],
  'R8.46': [('𝜆', '$lambda$')],
  'R8.61': [('QSL', '#_r8-cod[QSL]')],
  'R8.70': [('identifica al operador,', 'identifica al _operador_,')],
  'R8.85': [('EA4/M0ABC o EA/M0ABC', '#_r8-cod[EA4/M0ABC] o #_r8-cod[EA/M0ABC]')],
}
def apply(ov, key, text):
    for old,new in ov.get(key,[]):
        assert old in text, (key, old, text)
        text=text.replace(old,new)
    return text

entries,tabl=parse_sol()

def q_block(q):
    id=q['id']
    e=entries[id]
    stem=esc(join_lines(q['stem']))
    stem=apply(STEM_OV,id,stem)
    opts=[esc(join_lines(o)) for o in q['opts']]
    sol=apply(SOL_OV,id,esc(e['text']))
    lines=[f'#q("{id}", "{e["ans"]}",', f'  [{stem}],', '  (' + ', '.join(f'[{o}]' for o in opts) + '),', f'  sol: [{sol}],', ')']
    return '\n'.join(lines)

FILES={'R6':'r06','R7':'r07','R8':'r08','R9':'r09'}
LABELS={'R6.1':'r6-sec-regiones','R8.1':'r8-sec-autorizacion','R8.2':'r8-sec-antenas','R8.3':'r8-sec-usos-especiales','R8.4':'r8-sec-desatendidas','R8.5':'r8-sec-tipos','R8.6':'r8-sec-nomenclatura','R8.7':'r8-sec-uso'}

exec(open(T+'/prose.py').read())

def gen(key):
    items=parse_tema(key)
    out=[HEADER[key].strip('\n'),'']
    nq=0
    for it in items:
        if it[0]=='prose':
            continue
        if it[0]=='h':
            num,title=it[1],it[2]
            out.append(f'== {title} <{LABELS[num]}>\n')
            if ('h:'+num) in MID[key]:
                out.append(MID[key]['h:'+num].strip('\n')+'\n')
            continue
        q=it[1]
        out.append(q_block(q)+'\n')
        nq+=1
        if ('after:'+q['id']) in MID[key]:
            out.append(MID[key]['after:'+q['id']].strip('\n')+'\n')
    out.append(MID[key].get('post','').strip('\n'))
    txt='\n'.join(out).rstrip('\n')+'\n'
    open(ROOT+'chapters/'+FILES[key]+'.typ','w').write(txt)
    print(key,nq)

for k in ('R6','R7','R8','R9'):
    gen(k)
