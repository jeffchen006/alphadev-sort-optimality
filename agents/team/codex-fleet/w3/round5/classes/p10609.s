# n=5 model=out iset=I1 prefix14_class=10609
cmp P1, P0
mov S1, P1
cmovg P1, P0
mov S2, P3
cmovg P0, S1
cmp P2, P3
cmovl S2, P2
cmovle P2, P3
cmp P2, P0
cmovl P3, P2
cmovl P2, P0
cmovl P0, P3
mov S0, P1
cmp S2, P1
