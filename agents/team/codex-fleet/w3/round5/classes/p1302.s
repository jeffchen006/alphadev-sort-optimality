# n=5 model=out iset=I1 prefix14_class=1302
mov S2, P2
cmp P2, P0
cmovle P2, P0
mov S1, P3
cmovge S2, P0
cmp P3, P1
cmovle P3, P1
mov P0, P3
cmovl P1, S1
cmp P3, P2
cmovl P0, P2
cmovg P3, P2
cmovl P2, P3
cmp S2, P1
