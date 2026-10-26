from pathlib import Path
import subprocess
known={'known32.s','control_decoded.s','paired32.s','onehot_control32.s','paired42_mem.s','gate_control32.s','origin_control32.s','greedy84_inclusive.s','greedy94_mem.s','construct_fj_k53.s','construct_fj_L63_mem.s','union_control84.s','union_phase_control53.s','greedy_t5_common_last_k84.s'}
for p in sorted(Path('programs').glob('*.s')):
 if p.name in known or p.name=='prefix_fj.s':continue
 text=p.read_text();model='mem' if 'model=mem' in text.splitlines()[0] else 'out'
 r=subprocess.run(['nice','-n','10','python3','/path/to/repo/shared/judge.py',str(p),'--strict','--model',model],capture_output=True,text=True)
 Path('logs/'+p.stem+'.judge').write_text(r.stdout+r.stderr)
 print(r.stdout.strip(),flush=True)
