# n=5 model=out iset=I1 prefix14_class=8356
cmp P3, P1
mov S0, P1
cmovge S0, P3
cmovle P1, P3
cmp P0, P2
cmovg P3, P0
cmovge P0, P2
mov S2, P1
cmovg P2, P3
cmp P0, S2
mov S1, S0
cmovge S2, P0
cmovge P0, P1
mov P0, S2
