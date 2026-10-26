# n=5 model=out iset=I1 prefix14_class=1592
mov S2, P2
cmp P2, P1
cmovg S2, P1
mov S1, P0
cmovge P1, P2
cmp P3, S1
cmovl P0, P3
mov S0, S2
cmovg S1, P3
cmp S0, P0
cmovl S2, P0
cmovge S0, P0
cmp P1, S1
cmovge S0, S1
