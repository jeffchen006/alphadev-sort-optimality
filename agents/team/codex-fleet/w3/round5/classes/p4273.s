# n=5 model=out iset=I1 prefix14_class=4273
cmp P3, P0
mov S1, P3
cmovl S1, P0
cmovg P3, P0
mov P0, P1
cmp P1, P2
cmovg P1, P2
cmovge P2, P0
cmp P1, P3
cmovl P0, P3
cmovle P3, P1
cmovl P1, P0
cmp P2, S1
cmovg P0, P1
