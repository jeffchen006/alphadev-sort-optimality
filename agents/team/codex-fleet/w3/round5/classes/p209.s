# n=5 model=out iset=I1 prefix14_class=209
cmp P3, P2
mov S0, P0
cmovl S1, P3
cmovle P3, P2
cmovl P2, S1
cmp S0, P1
cmovg P0, P1
cmovg P1, S0
cmp P2, P0
mov S2, P2
mov S0, P1
cmovl P2, P0
mov S1, P2
cmovl P0, S2
