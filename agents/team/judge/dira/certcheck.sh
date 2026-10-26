#!/bin/bash
# usage: certcheck.sh CNF DRAT [TIMEOUT_S]  -> one line: verdict (VERIFIED / NOT VERIFIED / other)
T=${3:-20000}
P=/path/to/repo
out=$(nice -n 10 $P/bin/drat-trim "$1" "$2" -t $T 2>&1 | tr '\r' '\n')
v=$(echo "$out" | grep -E "^s " | tail -1); tm=$(echo "$out" | grep "verification time" | tail -1)
[ -z "$v" ] && v="s NO-VERDICT: $(echo "$out" | tail -1)"
echo "$1 :: $v :: $tm"
