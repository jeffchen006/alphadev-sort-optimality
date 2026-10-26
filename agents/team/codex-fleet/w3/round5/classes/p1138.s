# n=5 model=out iset=I1 prefix14_class=1138
cmp P0, P1
mov S2, P1
cmovge S2, P0
mov S1, P2
cmovle P1, P0
cmp P3, P2
cmovge S1, P3
cmovg P3, P2
cmp S2, S1
mov P2, S1
cmovg P2, S2
cmovle S1, S2
cmp P1, P3
cmovl S2, P3
