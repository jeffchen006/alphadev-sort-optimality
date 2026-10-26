#!/bin/bash
cd /path/to/repo/agents/team/d5-extend/pt
for f in pre/p*.txt; do b=$(basename $f .txt); PREFIX=6 nice timeout 3600 ./pairtrack $f 8 100000000 > pre/$b.sk 2> pre/$b.log; echo "$b $(wc -l < pre/$b.sk) $(tail -1 pre/$b.log)" >> pre/counts.txt; done
