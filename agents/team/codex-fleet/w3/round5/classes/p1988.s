# n=5 model=out iset=I1 prefix14_class=1988
mov S2, P0
cmp P3, P2
cmovge S1, P3
cmovg P3, P2
cmovle S1, P2
cmp P1, S2
cmovg S2, P1
cmovl P0, P1
cmovl P1, S2
cmp S2, S1
cmovl P1, S1
cmovl S1, S2
cmp P0, P3
cmovl P2, P0
