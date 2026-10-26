# n=5 model=out iset=I1 prefix14_class=13485
mov S1, P2
cmp P2, P0
cmovl S1, P0
cmovl P0, P2
cmp P1, P3
cmovge P2, P3
cmovle P2, P1
cmovl P1, P3
cmp P0, P2
mov P3, P2
cmovge P2, P0
cmovg P0, P3
cmp S1, P1
cmovle P3, S1
