#!/bin/bash
# Self-test of check_unsat.sh and cake_lpr (positive and negative cases).
cd "$(dirname "$0")"; P=..; C=$P/tools/bin/cake_lpr; fail=0
python3 gen_php.py 5 4 > php5_4.cnf; python3 gen_php.py 8 7 > php8_7.cnf; python3 gen_php.py 4 4 > php4_4_sat.cnf
t() { if [ "$2" = "$3" ]; then echo "PASS $1"; else echo "FAIL $1 (got $2 want $3)"; fail=1; fi; }
for f in php5_4 php8_7; do for s in cadical kissat; do
  $P/check_unsat.sh -x -T -s $s $f.cnf > /dev/null; t "$f/$s unsat text" $? 0
  $P/check_unsat.sh -s $s $f.cnf > /dev/null; t "$f/$s unsat" $? 0; done; done
$P/check_unsat.sh php4_4_sat.cnf > /dev/null; t "php4_4 sat" $? 10
# negative: valid proof of php5_4 must not verify a weaker CNF (one clause removed -> SAT)
$P/../../bin/cadical -q --lrat=true --binary=false php5_4.cnf neg.lrat > /dev/null
(head -1 php5_4.cnf | awk '{print $1,$2,$3,$4-1}'; tail -n +3 php5_4.cnf) > php5_4_weak.cnf
o=$($C php5_4_weak.cnf neg.lrat 2>&1); t "proof on weakened CNF rejected" "$o" "$(echo "$o" | grep -v '^s VERIFIED')"
# negative: corrupt proof (delete middle lemma lines)
n=$(wc -l < neg.lrat); sed "$((n/2)),$((n/2+3))d" neg.lrat > bad.lrat
o=$($C php5_4.cnf bad.lrat 2>&1); t "corrupted proof rejected" "$(echo "$o" | grep -c '^s VERIFIED UNSAT')" 0
# negative: empty proof
o=$($C php5_4.cnf /dev/null 2>&1); t "empty proof rejected" "$(echo "$o" | grep -c '^s VERIFIED UNSAT')" 0
rm -f neg.lrat bad.lrat; exit $fail
