# n=5 model=out iset=I1 prefix14_class=1202
mov S0, P3
cmp P3, P0
cmovl P3, P0
cmovl P0, S0
mov S0, P3
mov S1, P2
cmp S1, P1
cmovl S1, P1
cmovg P2, P1
cmp S0, S1
cmovg P3, S1
mov P1, P3
cmovge S1, S0
mov S2, P0
