# n=5 model=out iset=I1 prefix14_class=4571
cmp P3, P1
mov S0, P3
cmovg S0, P1
cmovge P1, P3
cmp P2, P0
mov P3, P2
cmovle P2, P0
cmovge P3, P0
mov S1, P2
cmp P1, S1
cmovle S1, P1
cmovge P2, P1
mov S2, S1
cmp P3, S0
