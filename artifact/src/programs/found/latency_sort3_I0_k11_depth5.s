# n=3 R=4 iset=I0 model=out source=latency/sweep.py (SAT, depth<=5; first cmovl replaced by mov) k=11 depthU=5 depthE=5 depthZ2=7
mov S0, P0
cmp P0, P1
cmovg P0, P1
cmovg P1, S0
mov S0, P2
cmp P0, P2
cmovl S0, P0
cmovl P0, P2
cmp P2, P1
cmovl P2, P1
cmovg P0, P1
out 0, S0
out 1, P0
out 2, P2
