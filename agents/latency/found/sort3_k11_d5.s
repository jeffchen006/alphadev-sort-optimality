# n=3 R=4 iset=I1 source=latency/sweep.py (first cmovle replaced by mov) k=11 free-output: out0=S0 out1=P0 out2=P2
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
