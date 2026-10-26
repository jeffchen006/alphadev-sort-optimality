# n=5 model=out iset=I1 prefix14_class=7808
mov S0, P2
cmp S0, P3
cmovg P2, P3
cmovl S0, P3
cmp P0, P1
cmovge S2, P0
cmovge P0, P1
cmovge P1, S2
cmp P0, P2
mov P3, P2
cmovl P3, P0
cmovge P2, P0
cmp S0, P1
mov P0, S0
