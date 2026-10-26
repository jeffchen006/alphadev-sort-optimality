# n=5 model=out iset=I1 prefix14_class=6698
mov S0, P3
cmp P2, P3
mov S1, P0
cmovl P3, P2
cmovl P2, S0
cmp P1, P0
cmovl S1, P1
cmovg P0, P1
cmp P2, P0
mov S0, P0
cmovle P0, P2
cmovg S0, P2
cmp S1, P3
cmovle P2, S1
