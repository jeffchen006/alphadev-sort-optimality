# n=5 model=out iset=I1 prefix14_class=9028
mov S2, P1
cmp P2, P3
cmovl S1, P3
cmovl P3, P2
cmovl P2, S1
cmp P0, S2
cmovg S2, P0
cmovg P0, P1
cmp P2, S2
mov S0, P2
cmovl S0, S2
cmovl S2, P2
cmp P3, P0
mov P1, P0
