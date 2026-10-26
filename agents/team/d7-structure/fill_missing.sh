#!/bin/bash
# d7: re-run missing items of a sweep. usage: fill_missing.sh PREFIX MKPOOL PKL N OUTFILE  (3 parallel, auto R, v2)
cd $(dirname $0)
P=$1; MK=$2; PKL=$3; N=$4; OUT=$5
comm -23 <(seq 0 $((N-1)) | sort) <(grep -oE "^${P}[0-9]+ .*(NONE|MIN|ABORT)" $OUT | awk '{print $1}' | sed "s/^$P//" | sort -u) | sort -n |
 xargs -P 3 -I{} sh -c "python3 $MK $PKL pools/fm_${P}{}.txt {} && nice -n 10 ./pool_bfs pools/fm_${P}{}.txt 31 0 2>/dev/null | grep -E '^R =|MIN|NONE|ABORT' | tr '\n' ' ' | sed 's/^/${P}{} /'; echo; rm -f pools/fm_${P}{}.txt" >> $OUT
