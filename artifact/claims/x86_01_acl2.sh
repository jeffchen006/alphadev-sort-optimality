#!/bin/bash
# CLAIM (x86 21:04): the CERTIFIED ACL2 x86isa model (books/projects/x86isa, certified with SBCL 2.4.9) = real x86-64 on the
# team's programs: 48 programs, 24000 (initial state, final state) vectors recorded on hardware (data/acl2_team_dump.txt),
# all GPRs, flags, memory, RIP compared: 0 mismatches. Uses the x86 agent's certified ACL2 build (agents/x86/ext, trust base).
# Expected: "programs=48 vectors=24000 mismatches=0". Time: see x86's log, 1 core.
source "$(dirname "$0")/../lib.sh"
X=$ROOT/agents/x86; D=$SRC/x86/data/acl2_team_dump.txt
export PATH=$X/ext/sbcl-inst/bin:$PATH SBCL_HOME=$X/ext/sbcl-inst/lib/sbcl
run python3 $SRC/x86/src/gen_acl2.py gen $D $OUT/acl2_team
(echo '(set-inhibit-output-lst (quote (proof-tree prove event summary)))'; cat $OUT/acl2_team/run.lisp) | nice -n 10 $X/ext/acl2/saved_acl2 > $OUT/acl2_team/out.txt 2>&1
run python3 $SRC/x86/src/gen_acl2.py cmp $D $OUT/acl2_team $OUT/acl2_team/out.txt
expect "programs=48 vectors=24000 mismatches=0"
finish
