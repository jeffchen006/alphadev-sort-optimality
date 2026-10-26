# n=5 model=out iset=I1 prefix14_class=144
mov S1, P1
cmp S1, P3
cmovl S1, P3
cmovge P1, P3
cmp P0, P2
cmovle P3, P2
cmovge P3, P0
cmovl P2, P0
cmp P2, P1
mov S2, P2
cmovl S2, P1
cmovge P2, P1
mov P2, S1
cmp P3, P2
