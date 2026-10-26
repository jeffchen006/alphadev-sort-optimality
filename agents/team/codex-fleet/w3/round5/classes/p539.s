# n=5 model=out iset=I1 prefix14_class=539
mov S1, P2
mov S2, P0
cmp S1, P3
cmovg P2, P3
cmovge P3, S1
cmp P0, P1
cmovge S2, P1
mov S0, S2
cmovge P1, P0
cmp P2, S0
cmovg S0, P2
mov P0, P1
cmovg P2, S2
cmp P3, P0
