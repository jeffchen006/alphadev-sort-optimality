from pathlib import Path
from verify import verify
import json,sys,time
HERE=Path(__file__).resolve().parent
sources=sorted((HERE/'candidates').glob('retime_*_neutral.s'))
start=int(sys.argv[1]) if len(sys.argv)>1 else 0
end=int(sys.argv[2]) if len(sys.argv)>2 else len(sources)
began=time.monotonic()
for i in range(start,min(end,len(sources))):
    if not verify(sources[i]):raise SystemExit(1)
    print(json.dumps(dict(index=i,file=str(sources[i]),seconds=time.monotonic()-began)),flush=True)
print(json.dumps(dict(done=True,count=min(end,len(sources))-start,seconds=time.monotonic()-began)),flush=True)
