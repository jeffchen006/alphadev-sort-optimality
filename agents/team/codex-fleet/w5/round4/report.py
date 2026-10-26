"""Append completed round4 results with the full strict-PASS file list."""
import collections,hashlib,json,re
from pathlib import Path
HERE=Path(__file__).resolve().parent

def counters(path):
    lines=Path(path).read_text().splitlines()
    done=next(x for x in reversed(lines) if x.startswith('DONE '))
    row={}
    for k,v in re.findall(r'(\w+)=([^ ]+)',done):
        try:row[k]=float(v) if '.'in v else int(v)
        except ValueError:row[k]=v
    return row

walk=counters(HERE/'logs/restart_a.log')
bridge=counters(HERE/'logs/bridge.log')
block=counters(HERE/'logs/block_repair.log')
novel_block=counters(HERE/'logs/novel_block_repair.log')
audit=json.loads((HERE/'flag_audit.json').read_text())
masked=json.loads((HERE/'masked_audit.json').read_text())
wide=json.loads((HERE/'solver_results.json').read_text())
narrow=json.loads((HERE/'narrow_results.json').read_text())
dest=json.loads((HERE/"destination_results.json").read_text())
structures=json.loads((HERE/"comparison_structures.json").read_text())
ledger={r['file']:r for r in map(json.loads,(HERE/'judge_ledger.jsonl').read_text().splitlines())}
assert (HERE/'restart_judges_done.json').exists()
assert (HERE/'bridge_judges_done.json').exists()
candidate_names={p.name for p in (HERE/'candidates').glob('*.s')}
judged_names={Path(r['file']).name for r in ledger.values() if r['model']=='out'}
assert candidate_names<=judged_names, candidate_names-judged_names
for row in ledger.values():
    path=Path(row['file']);log=Path(row['log'])
    assert row['passed'] and row['code']==0 and log.read_text().startswith('PASS '),row
    assert hashlib.sha256(path.read_bytes()).hexdigest()==row['sha256'],path
integrity=list(ledger.values())
(HERE/'verified_integrity.json').write_text(json.dumps(integrity,indent=2)+'\n')
summary=dict(restart=walk,bridge=bridge,block=block,novel_block=novel_block,
             audit_windows=len(audit['rows']),audit_pairs=sum(r.get('pairs_tested',0) for r in audit['rows']),
             audit_feasible=sum(r['feasible'] for r in audit['rows']),
             masked_windows=len(masked['rows']),masked_feasible=sum(r['feasible'] for r in masked['rows']),
             wide_results=wide,narrow_results=narrow,destination_results=dest,comparison_structures=structures,strict_pass_files=integrity)
(HERE/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
statuswide=dict(collections.Counter(r['status'] for r in wide))
statusnarrow=dict(collections.Counter(r['status'] for r in narrow))
statusdest=dict(collections.Counter(r["status"] for r in dest))
lines=['\n\n## Round 4: compare removal through flag reuse and restart walks','','### Purpose','',
'Find a core with k<=31 by removing a comparison and reusing earlier flags. Explore new programs through random restarts.','',
'No k<=31 core received a strict judge PASS in this round. The best strict PASS core remains k=32, with 42 memory instructions.','',
'### Terms','',
'Core length k counts MOV, CMP, and CMOV instructions. An output snapshot records one register value at one program step. A comparison block starts at a CMP and ends before the next CMP. A comparison column lists one operand value for each weak order. A SAT query asks whether Boolean constraints can all hold. UNSAT means that no assignment satisfies those encoded constraints.','',
'### Method','',
'Read rounds 1–3 first. This round changes the repair neighborhood. It does not rerun dagx, lattice enumeration, fixed-skeleton routing, or the earlier near-miss scans. The frozen manifest has 149 distinct instruction sequences from the 143 w6 round-2 representatives, the six retained w6 no-MOV forms, and the w5 palette form. One sequence overlaps those sources. See `round4/manifest.json`.','',
'All new search, compiler, simulator-check, and judge jobs use nice level 19. At most two CPU jobs run together. CPU affinity is 76–77. Walk, block-repair, and SAT jobs have a 2,800 MiB address-space limit. All writes stay in w5.','',
'#### Fixed-flag value tests','',
'A flag outcome is the equal, less, or greater result of a comparison. With flags fixed, MOV and CMOV can only select an entry register value on each outcome. The first test permits a separate entry source for every target and every flag outcome. It has no write-count limit. It tests removal of each comparison and merger of each adjacent comparison pair. For a merged pair, the remaining comparison can use any entry register pair, including equal operands and a fresh scratch register. Opposite operand orders give the same partitions and need not be repeated.','',
f'The completed test checked {len(audit["rows"]):,} windows and {summary["audit_pairs"]:,} remaining-comparison operand pairs. No window passed its necessary value test. Its required values preserve each later register read and each original output snapshot. The later test uses per-case dependencies through the suffix. It preserves the original suffix branches and only the values that those branches need. It checked the same {len(masked["rows"]):,} windows. No window passed. These results exclude the stated value-preserving replacements. They do not exclude arbitrary output-equivalent suffix changes. Both tests use scratch=7 and initial flags equal. Audit data: `round4/flag_audit.json`, `round4/masked_audit.json`.','',
'Each audit accepted all 1,192 original comparison blocks when their own flags were restored. The folded SAT transition encoding matched scalar execution on 100 random programs, 500 cases, and 9,000 instruction-result values. It rejected 100 deliberately wrong result bits. These sampled checks are not encoding proofs. See `round4/logs/test_audit.log` and `round4/logs/test_fold.log`.','',
'#### Completed finite block repairs','',
f'The new exact enumeration deletes one comparison and reuses the previous flags. Until the next comparison, every write can choose MOV or any of the four CMOV predicates. One selected write can also choose any source and destination from the seed registers plus one fresh register. Equal operands are included. Outputs can select new snapshots. The enumeration finished all 149 seeds and tested {block["trials"]:,} candidates. The concrete 16-case filter admitted {block["filters"]:,}. None passed the full independent simulator. Counts include duplicate programs from different selected-write positions. Log: `round4/logs/block_repair.log`.','',
'This scan differs from round 2 because it changes operands inside the removed comparison block and permits every block write to change between MOV and CMOV. The positive control duplicates one comparison, then removes a duplicate. The returned k=32 core passed both strict judges.','',
f'The same finite scan also finished one representative of each of the {novel_block["seeds"]} comparison-column forms absent from the frozen seeds. It tested {novel_block["trials"]:,} candidates. The filter admitted {novel_block["filters"]:,}. None passed the full independent simulator. The new source hashes are in `round4/novel_manifest.json`. Log: `round4/logs/novel_block_repair.log`.','',
'#### Correct-program walks','',
'Each accepted state passed the independent simulator on all 541 weak orders with conservative unknown scratch values and flags. Distinct-list counts use 64-bit hashes after scratch-register normalization. Every retained assembly sample listed below passed both reference judges. Internal states have simulator checks only.','',
'| Run | Proposals | Accepted transitions | Distinct instruction lists | Restarts | Candidate tests | Wall seconds |',
'|---|---:|---:|---:|---:|---:|---:|',
f'| Fixed length 32 | {walk["moves"]:,} | {walk["accepted"]:,} | {walk["unique"]:,} | {walk["restarts"]:,} | {walk["trials"]:,} | {walk["seconds"]} |',
f'| Lengths 32–34 | {bridge["moves"]:,} | {bridge["accepted"]:,} | {bridge["unique"]:,} | {bridge["resets"]:,} | {bridge["trials"]:,} | {bridge["seconds"]} |','',
f'The first walk restarts from a random frozen seed after 5,000 accepted transitions. It checks all single deletions in every new instruction list. It proposed {walk["flagsproposals"]:,} compare-to-write changes, including moved insertions and simultaneous predicate/source repairs. None was accepted. Every new list retained eight comparisons. Whole-block comparison inversion is an allowed neutral move and accounts for many accepted transitions.','',
f'The second walk permits insertions and deletions while keeping every state correct. It probes greedy deletion paths on copies after every 100 new lists. It completed {bridge["probes"]:,} probes; {bridge["down32"]:,} reached length 32. Each probe tries single deletions until it finds a correct one. At the final reached core, it tests every single deletion before stopping. The walk can continue from a longer state. Its length/comparison histogram is in `round4/logs/bridge.log`. Neither stochastic walk is an exhaustive exclusion.','',
'#### SAT queries','',
'The wider SAT queries remove one comparison, free all write operands and write opcodes in the selected window, and retain the seven remaining comparison positions. The remaining comparison operands inside the window are free. The local queries free the preceding block, the removed block, and one following block. They also allow one outside instruction change while retaining every comparison position. The merge queries free the last five original comparison blocks except for the removed comparison. They make no outside changes. Outputs are free snapshots.','',
f'Wider-query status counts: `{json.dumps(statuswide,sort_keys=True)}`. Each local query has a 20-second wall limit. Each merge query has a 35-second wall limit. The narrower queries keep write destinations fixed, free their sources and conditions inside the same three-block window, and allow no outside edits. Their wall limit is 12 seconds. Narrower-query status counts: `{json.dumps(statusnarrow,sort_keys=True)}`. A wall limit is UNKNOWN and gives no exclusion. The exact commands, register bounds, encoded case counts, and progress are in `round4/solver_results.json`, `round4/narrow_results.json`, and their log paths.','',
'All SAT queries fix initial scratch to a top sentinel and initial flags to equal. New weak orders are added after failed candidates. UNSAT, where reported, concerns only the stated finite query and its encoded weak orders. The k=32 SAT control passed both strict judges.','',
f'The final eight queries extend the narrow window by allowing at most one changed write destination. All write sources and conditions in the window remain free. Comparison operands remain free there. Each query has a 15-second wall limit. Status counts: `{json.dumps(statusdest,sort_keys=True)}`. The exact commands and logs are in `round4/destination_results.json`.','',
'#### Retained comparison structures','',
f'The comparison-column audit checked {structures["samples"]:,} saved k=32 states. The frozen seeds have {structures["known_full_classes"]} classes on all 541 weak orders and {structures["known_distinct_classes"]} classes on the 120 strict input orders. Input permutations, reversed value order, and reversal of comparison operands are identified. The samples contain {structures["new_full_classes"]} additional full-order classes; {structures["new_distinct_samples"]} samples have comparison columns outside the known strict-order classes. These counts concern saved states only. No general algorithmic novelty follows from a column identifier. See `round4/comparison_structures.json`.','',
'### Result','',
f'The completed ledger contains {len(integrity):,} strict PASS files. Every path, model, length, SHA-256 hash, and judge log is in `round4/verified_integrity.json`. Each row below lists the out and memory files. For a core length k, the memory length is k+10. All these lengths remain above the requested target.','',
'| Out PASS file | Memory PASS file | Core k |',
'|---|---|---:|']
for file,row in sorted(ledger.items()):
    if row['model']!='out':continue
    path=Path(file);mem=path.with_name(path.stem+'_mem.s')
    assert str(mem)in ledger
    rp=path.relative_to(HERE.parent);rm=mem.relative_to(HERE.parent)
    lines.append(f'| [{path.name}]({rp}) | [{mem.name}]({rm}) | {row["k"]} |')
lines += ['', '### Limits','', 'These are bounded neighborhood results and stochastic observations. No global lower bound follows. The conservative simulator can reject valid programs that depend on scratch-value correlations. No such rejection is treated as a strict PASS.', '', '### Conclusion','', 'The requested k<=31 core remains unfound. All round-4 jobs have finished.']
results=HERE.parent/'RESULTS.md'
assert '## Round 4:'not in results.read_text()
results.write_text(results.read_text()+'\n'.join(lines)+'\n')
print(json.dumps(dict(walk=walk,bridge=bridge,block=block,novel_block=novel_block,wide=statuswide,narrow=statusnarrow,destination=statusdest,strict_pass_files=len(integrity)),indent=2))
