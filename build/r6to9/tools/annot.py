import sys, re, xml.etree.ElementTree as ET
fn = sys.argv[1]
tree = ET.parse(fn)
root = tree.getroot()
fonts = {}
for fs in root.iter('fontspec'):
    fam = fs.get('family')
    kind = 'r'
    if 'LibertineOI' in fam: kind='i'
    elif 'LibertineOB' in fam: kind='b'
    elif 'Inconsolata' in fam: kind='m'
    elif 'Biolinum' in fam: kind='s'
    fonts[fs.get('id')] = (kind, fs.get('color'), fs.get('size'))
for page in root.iter('page'):
    print('=== PAGE', page.get('number'))
    # group by top
    items=[]
    for t in page.iter('text'):
        txt = ''.join(t.itertext())
        items.append((int(t.get('top')), int(t.get('left')), t.get('font'), txt))
    items.sort(key=lambda x:(x[0],x[1]))
    # merge same-line (within 4 px)
    lines=[]
    for it in items:
        if lines and abs(lines[-1][0]-it[0])<=6:
            lines[-1][2].append(it)
        else:
            lines.append([it[0], it[1], [it]])
    for top,left,its in lines:
        out=''
        for _,l,f,txt in its:
            k=fonts[f][0]
            if k=='r': out+=txt
            else: out+='<%s%s>%s</%s>'%(k, ('' if k!='s' else ''), txt, k)
        print(out)
