# n=5 model=out iset=I1 prefix14_class=13955
cmp P1, P3
mov S2, P1
cmovge S2, P3
cmovle P1, P3
cmp P2, P0
mov S1, P0
cmovle S1, P2
cmovg P0, P2
cmp P0, P1
cmovl P3, P1
cmovl P1, P0
cmovl P0, P3
cmp S2, S1
mov P0, P1
