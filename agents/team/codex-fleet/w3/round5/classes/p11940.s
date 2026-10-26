# n=5 model=out iset=I1 prefix14_class=11940
mov S2, P0
cmp P0, P2
cmovl S2, P2
cmovl P2, P0
mov S1, P3
cmp P3, P1
cmovl P3, P1
cmovl P1, S1
cmp S2, P3
cmovg S1, S2
cmovge S2, P3
cmovg P3, S1
cmp P1, P2
mov P3, P1
