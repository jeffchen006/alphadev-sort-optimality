# n=3 R=4 iset=I1 model=out source=latency/sweep.py (SAT, depth<=5; first cmovle replaced by mov) k=11 depthU=5 depthE=5 depthZ2=7
mov S0, P0
cmp P0, P1
cmovge P0, P1
cmovge P1, S0
mov S0, P2
cmp P0, P2
cmovl S0, P0
cmovle P0, P2
cmp P2, P1
cmovle P2, P1
cmovg P0, P1
out 0, S0
out 1, P0
out 2, P2
