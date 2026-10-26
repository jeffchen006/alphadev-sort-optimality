# n=5 model=out iset=I1 prefix14_class=5744
mov S1, P0
cmp P2, P3
cmovge S2, P3
cmovge P3, P2
cmovg P2, S2
cmp P1, P0
cmovge P0, P1
cmovg P1, S1
cmp P2, P1
cmovle S0, P2
cmovge S0, P1
cmovge P1, P2
cmp P0, P3
mov P2, P1
