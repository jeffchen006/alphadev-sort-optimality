#!/bin/bash
# x86 agent: run a generated run.lisp in the certified ACL2 x86isa and compare with hardware.
# Usage: run_acl2.sh DUMP DIR   (DIR made by: python3 src/gen_acl2.py gen DUMP DIR [MAXVEC])
D=$(cd "$(dirname "$0")" && pwd)
export PATH=$D/ext/sbcl-inst/bin:$PATH SBCL_HOME=$D/ext/sbcl-inst/lib/sbcl
(echo '(set-inhibit-output-lst (quote (proof-tree prove event summary)))'; cat $2/run.lisp) | nice -n 10 $D/ext/acl2/saved_acl2 > $2/out.txt 2>&1
python3 $D/src/gen_acl2.py cmp $1 $2 $2/out.txt
