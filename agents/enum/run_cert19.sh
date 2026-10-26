#!/bin/bash
# k<=19 certificate (format v1), n=4, I1, NG: disk-based BFS (EXTDIR, resumable: just rerun this script), 8 cores pinned
cd "$(dirname "$0")"
P=certs/sort4_I1_k19_ng1
taskset -c 160-191 nice -n 10 env NG=1 CMAX=10 EXTDIR=certs/ext19 CERTOUT=$P.cert /usr/bin/time -f "%es %MKB" ./bin/enum_out_v11 4 0 1 19 32 1 2>&1 || exit 1
grep -q "^END" <(tail -n 1 $P.cert) || ./certend.sh $P.cert
tail -n 1 $P.cert
taskset -c 160-191 pigz -p 32 -k -f $P.cert && sha256sum $P.cert.gz && ls -la $P.cert $P.cert.gz
