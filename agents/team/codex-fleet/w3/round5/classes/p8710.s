# n=5 model=out iset=I1 prefix14_class=8710
cmp P0, P2
mov S0, P2
cmovg P2, P0
cmovg P0, S0
cmp P1, P3
mov S2, P2
mov S1, P1
cmovg P1, P3
cmovl S1, P3
cmp S1, S2
cmovg S2, S1
cmovl P2, S1
mov S1, P2
mov S2, P1
