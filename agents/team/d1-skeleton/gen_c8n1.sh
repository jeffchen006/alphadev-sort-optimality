#!/bin/bash
mkdir -p sk/c8n1_tmp
for f in sk/c8u/*.txt sk/c8r2u/*.txt; do b=$(basename $f .txt); [ -d sk/c8n1/$b ] && continue; nice python3 neighx.py $f sk/c8n1_tmp/$b > /dev/null 2>&1 && mv sk/c8n1_tmp/$b sk/c8n1/$b; done
echo GEN DONE
