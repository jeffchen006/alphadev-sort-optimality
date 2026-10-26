# n=5 model=out iset=I1 prefix14_class=149
mov S1, P1
cmp S1, P3
cmovge P1, P3
cmovl S1, P3
cmp P0, P2
mov P3, P0
cmovle P3, P2
cmovl P2, P0
cmovle P0, P3
cmp P1, P2
cmovge S2, P1
cmovg P1, P2
cmovle S2, P2
cmp S1, P0
