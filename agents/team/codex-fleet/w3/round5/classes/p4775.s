# n=5 model=out iset=I1 prefix14_class=4775
cmp P1, P2
cmovl S1, P1
cmovl P1, P2
cmovl P2, S1
mov S2, P0
cmp S2, P3
cmovl P0, P3
cmovg S2, P3
cmp S2, P2
cmovg S1, P2
cmovg P2, S2
cmovg S2, S1
cmp P1, P0
mov S0, P1
