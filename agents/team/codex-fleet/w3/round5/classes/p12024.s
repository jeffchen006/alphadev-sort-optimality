# n=5 model=out iset=I1 prefix14_class=12024
mov S2, P3
mov S1, P0
cmp P2, P3
cmovl P3, P2
cmovl P2, S2
cmovg S2, P2
cmp S1, P1
cmovle P0, P1
cmovge S1, P1
cmp P3, S1
cmovle P1, S1
cmovl S1, P3
cmovle P3, P1
cmp S2, P0
