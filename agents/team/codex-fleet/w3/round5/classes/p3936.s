# n=5 model=out iset=I1 prefix14_class=3936
mov S1, P1
cmp P2, P3
cmovge S2, P3
cmovg P3, P2
cmovle S2, P2
cmp P0, S1
cmovle S1, P0
cmovle P0, P1
cmp S2, S1
mov P2, S2
cmovl S2, S1
cmovl S1, P2
mov S1, S2
cmp P3, P0
