"""Apply only the published flag-operand adapter to the optimized router."""
import difflib
import hashlib
import json
from pathlib import Path

base=Path('round10/src/dagx_safe.cpp').read_text()
flags=Path('round10/src/dagx_flags_safe.cpp').read_text()
fast=Path('round10/src/dagx_lb.cpp').read_text()
sm=difflib.SequenceMatcher(a=base.splitlines(keepends=True),b=flags.splitlines(keepends=True),autojunk=False)
changes=[]
aa=base.splitlines(keepends=True);bb=flags.splitlines(keepends=True)
for tag,a,b,c,d in sm.get_opcodes():
    if tag=='equal':continue
    old=''.join(aa[a:b]);new=''.join(bb[c:d])
    if not old:
        # Insertions use the preceding source line as an exact anchor.
        old=aa[a-1];new=aa[a-1]+new
    assert fast.count(old)==1,(tag,a,b,fast.count(old))
    fast=fast.replace(old,new,1)
    changes.append(dict(tag=tag,old_lines=[a,b],new_lines=[c,d]))
Path('round10/src/dagx_flags_fast.cpp').write_text(fast)
Path('round10/artifacts/fast_build.json').write_text(json.dumps(dict(changes=changes,hashes={p:hashlib.sha256(Path(p).read_bytes()).hexdigest() for p in ['round10/src/dagx_safe.cpp','round10/src/dagx_flags_safe.cpp','round10/src/dagx_lb.cpp','round10/src/dagx_flags_fast.cpp']}),indent=2))
print('Applied flag adapter changes:',len(changes))
