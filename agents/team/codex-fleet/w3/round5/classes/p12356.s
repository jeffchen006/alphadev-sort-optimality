# n=5 model=out iset=I1 prefix14_class=12356
cmp P3, P1
mov S1, P3
cmovl S1, P1
mov S2, S1
cmovge P3, P1
mov P1, P0
cmp P0, P2
cmovg P1, P2
cmovl P0, P2
cmp P3, P1
cmovle P2, P3
cmovle P3, P1
cmovle P1, P2
cmp S1, P0
