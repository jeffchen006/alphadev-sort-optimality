# n=5 model=out iset=I1 prefix14_class=12696
cmp P2, P1
cmovg S2, P1
cmovg P1, P2
cmovg P2, S2
mov S0, P2
cmp P0, P3
cmovl S2, P3
cmovl P3, P0
cmovl P0, S2
mov S1, P1
cmp P3, P2
cmovg S0, P3
cmovg P3, P2
cmp P0, S1
