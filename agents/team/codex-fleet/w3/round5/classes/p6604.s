# n=5 model=out iset=I1 prefix14_class=6604
cmp P3, P0
cmovg S1, P3
cmovle S1, P0
cmovle P0, P3
mov S2, P1
cmp P1, P2
cmovl P1, P2
cmovl P2, S2
cmp S1, P1
cmovl S2, S1
cmovge S2, P1
cmovg P1, S1
cmp P2, P0
cmovg P3, P0
