# n=5 model=out iset=I1 prefix14_class=8763
mov S2, P0
cmp P3, P0
cmovl S2, P3
cmovl P3, P0
mov P0, P1
cmp P2, P1
cmovg P0, P2
cmovl P1, P2
cmp P3, P0
cmovg S1, P3
cmovg P3, P0
cmovg P0, S1
cmp S2, P1
cmovge S1, S2
