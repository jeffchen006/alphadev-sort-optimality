# n=5 model=out iset=I1 prefix14_class=6609
mov S0, P1
cmp P0, S0
cmovl S0, P0
mov S2, P2
cmovg P1, P0
mov S1, P1
cmp P2, P3
cmovl P2, P3
cmovle P3, S2
cmp P1, P2
cmovl S1, P2
cmovg P1, P2
cmp P3, S0
cmovg P2, S0
