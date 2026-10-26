# n=5 model=out iset=I1 prefix14_class=5180
mov S1, P3
cmp S1, P1
cmovl S1, P1
cmovle P1, P3
cmp P0, P2
cmovl P3, P2
cmovl P2, P0
cmovl P0, P3
cmp P2, P1
cmovge P3, P2
cmovg P2, P1
cmovg P1, P3
mov P2, S1
cmp P0, P2
