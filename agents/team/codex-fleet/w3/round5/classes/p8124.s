# n=5 model=out iset=I1 prefix14_class=8124
mov S1, P3
cmp P2, S1
cmovle P3, P2
cmovle P2, S1
cmp P0, P1
mov S1, P3
cmovl S2, P1
cmovle P1, P0
cmovl P0, S2
cmp S1, P1
cmovge P3, P1
cmovl S1, P1
cmp P2, P0
mov P1, P2
