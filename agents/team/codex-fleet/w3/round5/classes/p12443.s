# n=5 model=out iset=I1 prefix14_class=12443
cmp P0, P1
cmovle S1, P1
cmovge S1, P0
cmovle P1, P0
mov S2, P3
cmp P3, P2
cmovg P3, P2
cmovl S2, P2
cmp P3, P1
cmovl P2, P1
cmovl P1, P3
cmovl P3, P2
mov P0, S1
cmp S2, S1
