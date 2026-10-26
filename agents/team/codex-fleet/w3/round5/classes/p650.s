# n=5 model=out iset=I1 prefix14_class=650
cmp P0, P2
cmovle S1, P2
cmovl P2, P0
cmovl P0, S1
mov S1, P1
cmp S1, P3
cmovl S1, P3
cmovg P1, P3
mov P3, S1
cmp S1, P0
cmovle S1, P0
cmovle P0, P3
cmp P1, P2
cmovge S1, P2
