# n=5 model=out iset=I1 prefix14_class=148
mov S1, P1
cmp S1, P3
cmovg P1, P3
cmovl S1, P3
cmp P0, P2
cmovge P3, P0
cmovle P3, P2
cmovl P2, P0
mov S2, P2
cmp P2, P1
cmovge P2, P1
mov P0, P3
cmovle S2, P1
cmp S1, P0
