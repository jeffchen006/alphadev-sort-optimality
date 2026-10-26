# n=5 model=out iset=I1 prefix14_class=10699
cmp P0, P2
cmovge S2, P0
mov S1, P1
cmovg P0, P2
cmovl S2, P2
cmp P3, P1
cmovle S1, P3
cmovg P1, P3
cmp P1, S2
cmovl P2, S2
cmovle S2, P1
cmovl P1, P2
cmp S1, P0
cmovl P1, S1
