# n=5 model=out iset=I1 prefix14_class=237
cmp P2, P0
cmovge S2, P2
mov S1, P3
cmovle S2, P0
cmovle P0, P2
cmp P3, P1
mov P2, P0
cmovge S1, P1
cmovg P1, P3
cmp S1, P2
cmovg P2, S1
cmovle P0, S1
cmovl S1, P2
mov P0, P1
