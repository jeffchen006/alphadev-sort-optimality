# n=5 model=out iset=I1 prefix14_class=625
cmp P2, P3
mov S0, P0
mov S1, P3
cmovge S1, P2
cmovge P2, P3
cmp P0, P1
cmovg S0, P1
cmovg P1, P0
cmp P1, S1
mov S2, S1
mov P0, S0
cmovge S1, P1
cmovle S2, P1
cmp P2, S0
