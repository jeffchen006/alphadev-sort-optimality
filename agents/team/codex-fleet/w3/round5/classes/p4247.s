# n=5 model=out iset=I1 prefix14_class=4247
cmp P3, P1
cmovge S0, P1
mov S1, P2
cmovge P1, P3
cmovg P3, S0
cmp P0, S1
cmovge S1, P0
cmovg P0, P2
cmp P0, P3
cmovge S2, P0
cmovl S2, P3
cmovl P3, P0
cmp S1, P1
mov P3, P1
