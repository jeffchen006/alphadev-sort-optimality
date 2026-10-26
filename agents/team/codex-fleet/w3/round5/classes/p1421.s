# n=5 model=out iset=I1 prefix14_class=1421
mov S0, P3
mov S2, P1
cmp S0, P0
cmovg S0, P0
cmovge P0, P3
cmp P2, S2
cmovge P1, P2
mov P3, P1
cmovg P2, S2
cmp P3, P0
cmovg P1, P0
cmovl P3, P0
cmp P2, S0
cmovge S1, P2
