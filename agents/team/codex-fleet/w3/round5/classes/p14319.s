# n=5 model=out iset=I1 prefix14_class=14319
cmp P1, P2
cmovl S0, P2
mov S1, P3
cmovle P2, P1
cmovl P1, S0
cmp P0, S1
cmovg P3, P0
cmovg P0, S1
mov S1, P2
cmp P2, P0
cmovl S1, P0
cmovg P2, P0
cmp P3, P1
cmovg P0, P3
