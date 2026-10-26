# n=5 model=out iset=I1 prefix14_class=12049
mov S1, P1
cmp P1, P3
cmovl S1, P3
cmovle P3, P1
cmp P0, P2
cmovl P1, P0
cmovl P0, P2
cmovl P2, P1
cmp P2, P3
mov S2, P2
cmovl P2, P3
cmovle P3, S2
cmp S1, P0
mov S2, P2
