import re
LOW='a-záéíóúñü'
def joinlines(lines, report=None, ctx=''):
    s='\n'.join(l.rstrip() for l in lines)
    def rep(m):
        a,m1,m2,b=m.group(1),m.group(2),m.group(3),m.group(4)
        if report is not None: report.append((ctx,a+'-'+'|'+b, 'both' if (m1 and m2) else ('one' if (m1 or m2) else 'none')))
        if m1 and m2: return a+b
        if not (m1 or m2): return a+b
        raise SystemExit('one-sided marker at hyphen: '+ctx)
    s=re.sub(r'(['+LOW+r'])-(⟦/[ibx]⟧)?\n(⟦[ibx]⟧)?(['+LOW+r'])',rep,s)
    s=re.sub(r'(\d)([-–])\n(?=\d)',lambda m:m.group(1)+m.group(2),s)
    s=re.sub(r'IE-\n(?=T/1311)','IE',s)
    for m in re.finditer(r'.{12}[-–]\n.{8}',s):
        raise SystemExit('unhandled line-end hyphen '+ctx+' '+repr(m.group(0)))
    s=s.replace('\n',' ')
    s=re.sub(r'⟦/([ib])⟧( ?)⟦\1⟧',r'\2',s)
    s=re.sub(r'(⟦/[ib]⟧) ([).,;:])',r'\1\2',s)
    s=re.sub(r'  +',' ',s)
    return s.strip()
