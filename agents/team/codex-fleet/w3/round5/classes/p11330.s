# n=5 model=out iset=I1 prefix14_class=11330
mov S1, P1
cmp P2, P3
cmovl S0, P3
cmovl P3, P2
cmovl P2, S0
cmp P0, S1
cmovg P1, P0
cmovg P0, S1
cmp P1, P2
mov S1, P1
cmovle P1, P2
cmovl P2, S1
cmp P0, P3
cmovle S2, P3
