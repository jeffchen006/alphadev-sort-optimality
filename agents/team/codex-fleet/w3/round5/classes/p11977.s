# n=5 model=out iset=I1 prefix14_class=11977
cmp P1, P3
mov S0, P2
mov S1, P3
cmovg P3, P1
cmovg P1, S1
cmp P2, P0
cmovl S0, P0
cmovl P0, P2
mov S2, P1
cmp P0, P1
cmovl P1, P0
cmovle P0, S2
cmp P3, S0
cmovle P2, P3
