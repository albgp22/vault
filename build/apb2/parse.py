import re, json, sys
sys.path.insert(0,'/Users/albertogarciaplanes/tmpradio/build/apb2')
from extract import load, lines_of, join_els

IDRE=re.compile(r'^C-[A-Z]+\d*\.\d+$')

def runs_to_markup(runs):
    out=[]
    for st,t in runs:
        if st=='sp': out.append(t); continue
        if st=='i': out.append('⟦i⟧'+t+'⟦/i⟧')
        elif st=='b': out.append('⟦b⟧'+t+'⟦/b⟧')
        elif st.startswith('x:'): out.append('⟦x⟧'+t+'⟦/x⟧')
        else: out.append(t)
    return ''.join(out)

def parse_B():
    B=load('B')
    secs=[]; qs=[]; cur=None; started=False; ojo=[]
    mode=None
    for p in range(244,264):
        for l in lines_of(B[p]):
            els=l['els']
            first=els[0]
            txt=''.join(e['txt'] for e in els)
            if p==244 and not started:
                if first['st']=='sb' and first['txt'].startswith('B.11.'):
                    started=True
                else:
                    continue
            if first['st']=='sb' and first['size']==18 and re.match(r'^B\.\d+\.',first['txt']):
                secs.append(re.sub(r'\s+',' ',first['txt']))
                cur=None; mode=None
                if first['txt'].startswith('B.19'): mode='ojo'
                continue
            if mode=='ojo' and not IDRE.match(first['txt']):
                ojo.append(runs_to_markup(join_els(els)))
                continue
            if first['st']=='sb' and IDRE.match(first['txt']):
                mode=None
                cur=dict(id=first['txt'],stem=[],opts=[],page=p,sec=len(secs))
                qs.append(cur)
                rest=els[1:]
                if rest: cur['stem'].append(runs_to_markup(join_els(rest)))
                continue
            if cur is None: 
                print('ORPHAN B',p,txt[:60]); continue
            # option label?
            if first['st']=='s' and re.match(r'^[a-d]\)$',first['txt']):
                cur['opts'].append([runs_to_markup(join_els(els[1:]))])
                continue
            if cur['opts']:
                cur['opts'][-1].append(runs_to_markup(join_els(els)))
            else:
                cur['stem'].append(runs_to_markup(join_els(els)))
    return secs,qs,ojo

def parse_D():
    D=load('D')
    items=[]; cur=None; started=False; done=False
    tables=[]
    for p in range(400,425):
        for l in lines_of(D[p]):
            els=l['els']; first=els[0]
            txt=''.join(e['txt'] for e in els)
            if not started:
                if first['st']=='sb' and txt.startswith('Tema R1.'):
                    started=True; items.append(('H','Tema R1. Alfabeto fonético internacional'))
                continue
            if txt.startswith('D.21.'): done=True; break
            if first['st']=='sb' and first['size']==16:   # headings
                items.append(('H',re.sub(r'\s+',' ',first['txt']))); cur=None
                continue
            if first['txt'] in ('Pregunta','Respuesta') and first['st']=='sb':
                tables.append((first['txt'],[e['txt'] for e in els[1:]]))
                continue
            if first['st']=='sb' and IDRE.match(first['txt']):
                cur=dict(id=first['txt'],page=p,lines=[],kind='sol',ans=None)
                items.append(('Q',cur))
                rest=els[1:]
                if rest and rest[0]['st']=='sb' and re.match(r'^\([a-d]\)$',rest[0]['txt']):
                    cur['ans']=rest[0]['txt'][1]
                    rest=rest[1:]
                if rest: cur['lines'].append(('sol',runs_to_markup(join_els(rest))))
                continue
            if cur is None:
                print('ORPHAN D',p,txt[:60]); continue
            if first['st']=='sb' and first['txt'].startswith('NO ESTÁ EN EL TEXTO'):
                cur['lines'].append(('noest',runs_to_markup(join_els(els[1:])))); continue
            if first['st']=='sb' and first['txt'].startswith('CLAVE DE LOS BANCOS'):
                cur['lines'].append(('clave',runs_to_markup(join_els(els[1:])))); continue
            cur['lines'].append(('cont',runs_to_markup(join_els(els))))
        if done: break
    return items,tables

if __name__=='__main__':
    secs,qs,ojo=parse_B()
    print(secs); print(len(qs)); print(ojo)
    items,tables=parse_D()
    print(len([i for i in items if i[0]=='Q']))
    print(tables[:4])
