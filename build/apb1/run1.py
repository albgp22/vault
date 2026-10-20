import sys, re
sys.path.insert(0,'.')
import s2, s3
entries, joins = s2.solutions()
out=[]
for e in entries:
    for kind, t in e['paras']:
        c = s3.convert_para(t)
        out.append((e['id'], kind, c))
import pickle
pickle.dump(out, open('conv1.pkl','wb'))
for i,k,c in out:
    if '$' in c or '#super' in c or '#sub' in c:
        # print only the math fragments with context
        for m in re.finditer(r'.{0,25}(\$[^$]*\$|#super\[[^\]]*\]|#sub\[[^\]]*\]).{0,15}', c):
            print(i, '|', m.group(0))
