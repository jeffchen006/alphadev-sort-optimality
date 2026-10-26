# n=5 model=out iset=I1 prefix14_class=1278
cmp P0, P3
cmovg S1, P3
cmovge P3, P0
cmovg P0, S1
cmp P2, P1
mov S2, P1
mov S0, P3
cmovge S2, P2
cmovl P1, P2
cmp S0, S2
cmovl S0, S2
cmovge P3, S2
mov P2, P0
cmp P0, P1
