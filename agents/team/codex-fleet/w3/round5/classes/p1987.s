# n=5 model=out iset=I1 prefix14_class=1987
mov S2, P3
cmp P0, P2
cmovge S1, P0
cmovg P0, P2
cmovle S1, P2
cmp P1, S2
cmovg S2, P1
cmovl P3, P1
cmovl P1, S2
cmp S2, S1
cmovl P1, S1
cmovl S1, S2
cmp P3, P0
cmovl P2, P3
