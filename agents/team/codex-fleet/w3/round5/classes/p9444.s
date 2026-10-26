# n=5 model=out iset=I1 prefix14_class=9444
mov S1, P0
mov S2, P2
cmp S1, P3
cmovg S1, P3
cmovl P0, P3
cmp P2, P1
cmovl S2, P1
cmovg P2, P1
cmp P2, S1
cmovl S0, S1
cmovl S1, P2
mov S1, P0
cmovl P2, S0
cmp S2, S1
