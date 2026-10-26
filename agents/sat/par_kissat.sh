#!/bin/bash
# usage: par_kissat.sh <timeout> <cnf>...  : kissat on each file in parallel; prints status and wall time
to=$1; shift
for f in "$@"; do
  ( s=$(date +%s); r=$(timeout $to nice -n 10 /path/to/repo/bin/kissat -q "$f" | grep "^s"); e=$(date +%s); echo "$f ${r:-TIMEOUT} $((e-s))s" ) &
done
wait
