# n=5 model=out iset=I1 prefix14_class=9387
mov S1, P3
cmp S1, P2
cmovg P3, P2
cmovle S1, P2
mov S2, P1
cmp P0, P1
cmovl S2, P0
cmovle P0, P1
cmp S2, P3
cmovg P2, S2
mov P1, S1
cmovge S2, P3
cmovg P3, P2
cmp S1, P0
