import re, html, json, sys
ROOT='/Users/albertogarciaplanes/tmpradio/build/apb2-x/'
ITALIC={'6','7','9','14','15'}   # per-file; recomputed from fontspec
def load(name):
    s=open(ROOT+name+'.xml').read()
    fonts={}
    for m in re.finditer(r'<fontspec id="(\d+)" size="(\d+)" family="([^"]*)" color="([^"]*)"/>',s):
        fam=m.group(3).split('+')[-1]
        fonts[m.group(1)]=dict(size=int(m.group(2)),fam=fam,color=m.group(4))
    pages={}
    parts=re.split(r'<page number="(\d+)"',s)
    for i in range(1,len(parts),2):
        num=int(parts[i]); body=parts[i+1]
        els=[]
        for m in re.finditer(r'<text top="(\d+)" left="(\d+)" width="(\d+)" height="(\d+)" font="(\d+)">(.*?)</text>',body):
            top,left,width,height,font,txt=m.groups()
            txt=html.unescape(re.sub(r'<[^>]+>','',txt))
            f=fonts[font]
            fam=f['fam']
            if 'LibertineO' in fam and fam.endswith('OI-Identity-H') or fam.startswith('LinLibertineOI'):
                st='i'
            elif fam.startswith('LinLibertineOB'):
                st='b'
            elif fam.startswith('LinBiolinumOB') :
                st='sb'
            elif fam.startswith('Inconsolata'):
                st='m'
            elif fam.startswith('LinBiolinumO'):
                st='s'
            elif fam.startswith('LinLibertineO'):
                st='r'
            else:
                st='x:'+fam
            els.append(dict(top=int(top),left=int(left),width=int(width),height=int(height),font=font,txt=txt,st=st,color=f['color'],size=f['size']))
        pages[num]=els
    return pages

def lines_of(els, lo=100, hi=1180, tol=9):
    els=[e for e in els if lo<=e['top']<=hi]
    els.sort(key=lambda e:(e['top'],e['left']))
    lines=[]
    for e in els:
        if lines and abs(e['top']-lines[-1]['ref'])<=tol:
            lines[-1]['els'].append(e)
        else:
            lines.append(dict(ref=e['top'],els=[e]))
    for l in lines:
        l['els'].sort(key=lambda e:e['left'])
    return lines

def join_els(els):
    """join elements of a line with gap-based spacing, return list of (st, text) runs"""
    runs=[]
    prev=None
    for e in els:
        if prev is not None:
            gap=e['left']-(prev['left']+prev['width'])
            if gap>1.5:
                runs.append(('sp',' '))
        runs.append((e['st'],e['txt']))
        prev=e
    return runs
if __name__=='__main__':
    D=load('D')
    for p in (408,):
        for l in lines_of(D[p]):
            print(p,l['ref'],[ (e['st'],e['txt'][:25]) for e in l['els']][:6])
