#!/bin/bash
# d7 [A8, pair tracking]: c=8 class pools + one complementary select pair on one flag, K=31, auto R, v2. 3 parallel.
cd $(dirname $0)
while ps -p 1678820 >/dev/null; do sleep 60; done
for s in w6 c8_2 c8_3; do
  N=$(python3 -c "import pickle;print(len(pickle.load(open('swap_$s.pkl','rb'))[1]))")
  seq 0 $((N-1)) | xargs -P 3 -I{} sh -c "python3 mkpool_swap.py swap_$s.pkl pools/sw_${s}_{}.txt {} && nice -n 10 ./pool_bfs pools/sw_${s}_{}.txt 31 0 2>/dev/null | grep -E '^R =|MIN|NONE|ABORT' | tr '\n' ' ' | sed 's/^/sw_${s}_{} /'; echo; rm -f pools/sw_${s}_{}.txt" > bfs_swap_$s.txt
done
