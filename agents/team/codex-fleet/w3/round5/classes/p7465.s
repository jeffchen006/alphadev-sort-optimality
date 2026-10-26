# n=5 model=out iset=I1 prefix14_class=7465
mov S0, P2
cmp P0, P2
mov S1, P3
cmovl P2, P0
cmovg S0, P0
cmp P1, S1
cmovl S1, P1
cmovle P1, P3
cmp P2, S1
cmovl P3, P2
cmovle P2, S1
cmovl S1, P3
cmp P1, S0
mov S2, S0
