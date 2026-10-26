# n=5 model=out iset=I1 prefix14_class=11859
mov S1, P3
cmp P0, P1
mov S2, P1
cmovge S2, P0
cmovle P1, P0
cmp S1, P2
cmovle P3, P2
cmovg S1, P2
cmp S2, P3
cmovle P2, S2
cmovl S2, P3
cmovl P3, P2
cmp P1, S1
cmovl P0, P1
