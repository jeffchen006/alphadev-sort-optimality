# n=5 model=out iset=I1 prefix14_class=3937
cmp P2, P0
cmovle S2, P2
cmovge S2, P0
mov S1, P1
cmovg P0, P2
cmp P3, S1
cmovle S1, P3
cmovl P3, P1
cmp S2, S1
cmovle P2, S2
cmovle S2, S1
cmovl S1, P2
mov P2, P3
mov S1, S2
