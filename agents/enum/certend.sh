#!/bin/bash
# append the END line of cert format v1: END <states> <sha256 of all previous bytes>
f="$1"; n=$(awk '$1=="S"{print $2; exit}' "$f"); h=$(sha256sum "$f" | cut -d' ' -f1); echo "END $n $h" >> "$f"
