# n=5 model=out iset=I1 prefix14_class=1728
mov S2, P1
cmp P1, P0
cmovl S2, P0
cmovle P0, P1
cmp P2, P3
mov S0, P3
cmovle P3, P2
mov P1, P0
cmovl P2, S0
cmp P3, P1
cmovle P1, P3
cmovg P0, P3
cmp S2, P2
mov P1, P2
