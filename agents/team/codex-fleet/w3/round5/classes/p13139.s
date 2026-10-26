# n=5 model=out iset=I1 prefix14_class=13139
cmp P2, P0
mov S2, P2
cmovg S2, P0
cmovl P2, P0
cmp P3, P1
cmovl S0, P3
mov S1, S2
cmovl P3, P1
cmovl P1, S0
cmp S1, P1
cmovg S2, P1
cmovg P1, S1
mov S2, P3
cmp S2, P2
