# n=5 model=out iset=I1 prefix14_class=649
cmp P0, P2
mov S1, P2
cmovl S1, P0
cmovl P0, P2
mov P2, P3
cmp P2, P1
cmovg P3, P1
cmovl P2, P1
mov P1, P2
cmp P2, P0
cmovle P2, P0
cmovle P0, P1
mov P1, P3
cmp S1, P3
