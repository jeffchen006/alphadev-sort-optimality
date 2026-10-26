# n=5 model=out iset=I1 prefix14_class=1589
cmp P2, P1
cmovge S2, P2
mov S1, P0
cmovge P2, P1
mov S0, P2
cmovg P1, S2
cmp P3, S1
cmovl P0, P3
cmovge S1, P3
cmovl P3, S1
cmp S0, P0
cmovg S0, P0
cmovl P2, P0
cmp P1, P3
