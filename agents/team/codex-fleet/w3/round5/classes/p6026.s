# n=5 model=out iset=I1 prefix14_class=6026
cmp P2, P3
cmovle S2, P3
cmovle P3, P2
cmovle P2, S2
cmp P0, P1
mov S1, P1
cmovl P1, P0
cmovle P0, S1
mov S2, P2
cmp S2, P0
cmovge S2, P0
cmovg P0, P2
cmp P3, P1
cmovl S1, P3
