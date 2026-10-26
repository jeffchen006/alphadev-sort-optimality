# n=5 model=out iset=I1 prefix14_class=1991
mov S2, P0
cmp P3, P1
mov S1, P3
cmovl S1, P1
cmovge P3, P1
cmp P2, P0
cmovl S2, P2
cmovge P0, P2
cmovl P2, P0
cmp P2, S1
cmovle P0, S1
cmovle S1, P2
cmp S2, P3
cmovle P0, S2
