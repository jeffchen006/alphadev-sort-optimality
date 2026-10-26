# n=5 model=out iset=I1 prefix14_class=8283
mov S1, P1
cmp P3, P1
cmovg S1, P3
mov S0, P0
cmovl P1, P3
cmp P2, S0
cmovg P0, P2
cmovl S0, P2
cmp P1, S0
mov P2, S0
cmovg P2, P1
cmovg P1, S0
cmp S1, P0
cmovg S2, P0
