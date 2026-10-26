# n=5 model=out iset=I1 prefix14_class=12524
mov S2, P2
cmp P3, S2
cmovl S2, P3
cmovl P3, P2
mov S0, P1
cmp P1, P0
cmovg P1, P0
cmovg P0, S0
cmp P1, S2
cmovge S1, S2
cmovge S2, P1
cmovg P1, S1
cmp P0, P3
mov P2, P0
