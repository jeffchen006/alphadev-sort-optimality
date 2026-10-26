# n=5 model=out iset=I1 prefix14_class=11074
mov S2, P3
cmp S2, P2
cmovl S2, P2
mov S1, P1
cmovl P2, P3
cmp S1, P0
cmovl S1, P0
cmovle P0, P1
cmp S1, S2
cmovl P1, S2
cmovl S2, S1
cmovl S1, P1
cmp P2, P0
mov S1, P2
