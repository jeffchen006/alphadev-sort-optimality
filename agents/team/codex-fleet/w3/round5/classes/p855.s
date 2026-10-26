# n=5 model=out iset=I1 prefix14_class=855
cmp P0, P3
mov S2, P2
mov S1, P3
cmovge S1, P0
cmovge P0, P3
cmp S2, P1
cmovge S2, P1
cmovg P1, P2
mov S0, S2
mov P2, S1
cmp P1, P2
cmovge P2, P1
cmovg P1, S1
cmp P0, S2
