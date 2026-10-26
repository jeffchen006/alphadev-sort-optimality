# n=5 model=out iset=I1 prefix14_class=8166
mov S2, P3
cmp S2, P1
cmovle S2, P1
cmovle P1, P3
cmp P0, P2
cmovge S1, P0
cmovg P0, P2
cmovg P2, S1
cmp P1, P0
mov P3, P1
cmovg P3, P0
cmovl P1, P0
cmp P2, S2
mov P3, P2
