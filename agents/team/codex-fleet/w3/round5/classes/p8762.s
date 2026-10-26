# n=5 model=out iset=I1 prefix14_class=8762
mov S2, P1
cmp P0, P1
cmovl S2, P0
cmovle P0, P1
cmp P2, P3
cmovle P1, P3
cmovg P1, P2
cmovl P3, P2
cmp P0, P1
cmovg S1, P0
cmovg P0, P1
cmovg P1, S1
cmp S2, P3
cmovge S1, S2
