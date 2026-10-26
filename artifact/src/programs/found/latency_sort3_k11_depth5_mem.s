# n=3 R=7 iset=I1 model=mem source=latency/sweep.py (SAT, depth<=5; first cmovle replaced by mov) k=11 depthU=5 depthE=5 depthZ2=7 (out2mem)
mov S1, P0
mov S2, P1
mov S3, P2
mov S0, S1
cmp S1, S2
cmovge S1, S2
cmovge S2, S0
mov S0, S3
cmp S1, S3
cmovl S0, S1
cmovle S1, S3
cmp S3, S2
cmovle S3, S2
cmovg S1, S2
mov P0, S0
mov P1, S1
mov P2, S3
