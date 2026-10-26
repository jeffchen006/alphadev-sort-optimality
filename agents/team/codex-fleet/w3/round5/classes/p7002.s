# n=5 model=out iset=I1 prefix14_class=7002
cmp P1, P2
cmovl S2, P2
cmovl P2, P1
cmovl P1, S2
mov S0, P2
mov S1, P3
cmp P3, P0
cmovle P3, P0
cmovl P0, S1
mov S1, P1
cmp S0, P0
cmovg S0, P0
cmovl P2, P0
cmp S1, P3
