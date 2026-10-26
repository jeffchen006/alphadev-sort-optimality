# n=5 model=out iset=I1 prefix14_class=1608
mov S2, P3
cmp S2, P2
mov S0, P0
cmovl P3, P2
cmovg S2, P2
cmp P1, S0
cmovg S0, P1
cmovl P0, P1
cmovge P1, P0
cmp S2, P1
cmovl P0, S2
cmovl S2, P1
cmp P3, S0
cmovge P1, S0
