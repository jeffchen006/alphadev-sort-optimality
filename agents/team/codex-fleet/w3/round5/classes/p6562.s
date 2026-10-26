# n=5 model=out iset=I1 prefix14_class=6562
cmp P2, P3
mov S2, P0
cmovle S1, P3
cmovge S1, P2
cmovg P2, P3
cmp S2, P1
cmovl S2, P1
cmovl P1, P0
cmp S2, S1
cmovl P3, S1
cmovl S1, S2
cmovl S2, P3
cmp P2, P1
cmovge P0, P1
