# n=5 model=out iset=I1 prefix14_class=643
cmp P0, P2
mov S1, P0
cmovl P0, P2
cmovge S1, P2
mov S2, P1
cmp S2, P3
cmovg S2, P3
cmovl P1, P3
mov P3, P1
cmp P3, P0
cmovl P3, P0
cmovl P0, P1
cmp S2, S1
cmovg P1, S1
