# n=5 model=out iset=I1 prefix14_class=7096
mov S0, P2
cmp P0, S0
cmovg P2, P0
cmovg P0, S0
mov S1, P1
cmp P1, P3
cmovg P1, P3
cmovg P3, S1
cmp P1, P0
mov S2, P0
cmovl P0, P1
cmovg S2, P1
cmp P2, P3
cmovl P0, P3
