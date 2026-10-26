# n=5 model=out iset=I1 prefix14_class=8606
cmp P2, P3
cmovl S1, P3
cmovge S1, P2
cmovl P3, P2
cmp P1, P0
cmovg S0, P0
cmovge P0, P1
mov P2, P3
cmovg P1, S0
mov S2, S1
cmp S2, P0
cmovge S2, P0
cmovge P0, S1
cmp P2, P1
