# n=5 model=out iset=I1 prefix14_class=5297
cmp P1, P3
mov S2, P1
mov S1, P0
cmovge P1, P3
cmovg P3, S2
cmp S1, P2
cmovg P0, P2
mov S2, P0
cmovl S1, P2
cmp P0, P1
cmovle S2, P1
cmovle P1, P0
cmp S1, P3
cmovl P0, P3
