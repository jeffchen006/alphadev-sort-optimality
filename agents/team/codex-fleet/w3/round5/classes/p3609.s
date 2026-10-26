# n=5 model=out iset=I1 prefix14_class=3609
mov S0, P1
cmp S0, P2
cmovl S0, P2
cmovle P2, P1
mov S1, P0
cmp P3, P0
cmovl P0, P3
cmovl P3, S1
cmp P2, P0
cmovl S1, P0
cmovle P0, P2
cmovl P2, S1
cmp P3, S0
cmovg S1, S0
