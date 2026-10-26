# n=5 model=out iset=I1 prefix14_class=2579
cmp P3, P1
cmovge S0, P1
cmovg P1, P3
cmovg P3, S0
cmp P2, P0
mov S1, P0
cmovg S1, P2
cmovg P2, P0
cmp S1, P1
cmovl S2, S1
cmovl S1, P1
cmovge S2, P1
cmp P3, P2
mov P0, S2
