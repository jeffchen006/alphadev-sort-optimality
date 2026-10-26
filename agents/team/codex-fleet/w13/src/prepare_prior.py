"""Add raw w8 keys, external file lists, and w6's saved out programs."""
import hashlib,json,subprocess
from pathlib import Path

ROOT=Path('/path/to/repo')
W8=ROOT/'agents/team/codex-fleet/w8'
W6=ROOT/'agents/team/codex-fleet/w6'

def run(cmd,tag):
    r=subprocess.run(cmd,capture_output=True,text=True,check=True)
    Path('logs',tag+'.log').write_text(r.stdout+r.stderr)

def main():
    raw=W8/'sk/nonlattice_prior_keys.txt'
    run(['./generate','--import-keys',str(raw),'sk/raw_prior.keys'],'prior_import')
    paths=set()
    for name in ('round4_prior_files.txt','round2_excluded_files.txt'):
        for line in (W8/'sk'/name).read_text().splitlines():
            file=Path(line)
            if not file.is_absolute():file=W8/file
            file=file.resolve()
            if not file.is_relative_to(W8):paths.add(str(file))
    for file in W6.rglob('*.s'):
        if any(x in file.parts for x in ('candidates','verified_mem')):continue
        if file.stem.endswith('_mem'):continue
        paths.add(str(file))
    filelist=Path('sk/external_prior.paths');filelist.write_text('\n'.join(sorted(paths))+'\n')
    run(['./generate','--index-list',str(filelist),'sk/external_prior.keys'],'prior_external')
    keys=set()
    for name in ('prior','raw_prior','external_prior'):
        keys.update(Path('sk',name+'.keys').read_text().splitlines())
    Path('sk/prior_full.keys').write_text('\n'.join(sorted(keys))+'\n')
    base=set(Path('sk/prior.keys').read_text().splitlines())
    result=dict(base_keys=len(base),full_keys=len(keys),added_keys=len(keys-base),external_paths=len(paths),raw_keys_sha256=hashlib.sha256(raw.read_bytes()).hexdigest(),full_index_sha256=hashlib.sha256(Path('sk/prior_full.keys').read_bytes()).hexdigest())
    # The first pass started before these additional sources were indexed.
    allrows=[];new=[];matches=[]
    for folder in ('sk/c8_full6','sk/c9_full4'):
        for line in Path(folder,'manifest.jsonl').read_text().splitlines():
            row=json.loads(line);keyfile=Path(row['file']+'.key')
            key=keyfile.read_text().strip() if keyfile.exists() else subprocess.check_output(['./generate','--key',row['file']],text=True).strip()
            keyfile.write_text(key+'\n');allrows.append(row)
            if key in keys:matches.append(row)
            else:new.append(row)
    Path('sk/first_novel.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in new))
    Path('sk/first_prior_matches.jsonl').write_text(''.join(json.dumps(r)+'\n' for r in matches))
    result.update(first_generated=len(allrows),first_novel=len(new),first_prior_matches=len(matches))
    Path('logs/prior_full.json').write_text(json.dumps(result,indent=2)+'\n')
    # New waves exclude the complete prior set plus every first-wave record.
    combined=keys|{Path(r['file']+'.key').read_text().strip() for r in allrows}
    Path('sk/combined.keys').write_text('\n'.join(sorted(combined))+'\n')
    print(json.dumps(result),flush=True)

if __name__=='__main__':main()
