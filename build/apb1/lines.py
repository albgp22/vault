import re, sys, html, statistics
S='/Users/albertogarciaplanes/tmpradio/build/apb1/'
def load(path, first_page):
    t=open(path).read()
    pages=re.split(r'<page ',t)[1:]
    out=[]
    for pi,p in enumerate(pages):
        lines=[]
        for lm in re.finditer(r'<line xMin="([\d.]+)" yMin="([\d.]+)" xMax="([\d.]+)" yMax="([\d.]+)">(.*?)</line>',p,re.S):
            x0,y0,x1,y1=map(float,lm.groups()[:4])
            words=[]
            for wm in re.finditer(r'<word xMin="([\d.]+)" yMin="([\d.]+)" xMax="([\d.]+)" yMax="([\d.]+)">(.*?)</word>',lm.group(5)):
                a,b,c,d=map(float,wm.groups()[:4]); words.append((a,b,c,d,html.unescape(wm.group(5))))
            lines.append(((x0,y0,x1,y1),words))
        out.append((first_page+pi,lines))
    return out
def annotate(words):
    # returns list of (text, kind) kind in '', '^', '_'
    hs=[w[3]-w[1] for w in words]
    cys=[(w[1]+w[3])/2 for w in words]
    if not words: return []
    hmax=max(hs)
    big=[cys[i] for i in range(len(words)) if hs[i]>=hmax*0.9]
    cref=statistics.median(big)
    res=[]
    for i,w in enumerate(words):
        k=''
        if hs[i]<hmax*0.88 :
            if cys[i]<cref-1.2: k='^'
            elif cys[i]>cref+0.8: k='_'
        res.append((w[4],k,w))
    return res
if __name__=='__main__':
    pages=load(S+'bboxL.html',372)
    pg=int(sys.argv[1])
    for n,lines in pages:
        if n!=pg: continue
        for bb,words in lines:
            a=annotate(words)
            s=' '.join((f'[{k}{t}]' if k else t) for t,k,_ in a)
            print(f'{bb[1]:.0f} {s}')
