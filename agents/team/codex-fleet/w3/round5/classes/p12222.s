# n=5 model=out iset=I1 prefix14_class=12222
cmp P1, P0
cmovl S0, P1
cmovl P1, P0
cmovl P0, S0
cmp P3, P2
mov S2, P2
cmovl P2, P3
cmovle P3, S2
mov S1, P0
cmp P2, P0
cmovl S1, P2
cmovg P0, P2
cmp P3, P1
mov P2, P3
