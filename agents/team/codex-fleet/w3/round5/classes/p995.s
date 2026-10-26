# n=5 model=out iset=I1 prefix14_class=995
mov S2, P2
cmp P3, S2
mov S0, P0
cmovge S2, P3
cmovl P2, P3
cmp S0, P1
cmovge P0, P1
cmovg P1, S0
cmp S2, P1
cmovge S0, P1
cmovge P1, S2
cmovg S2, S0
mov S1, P2
cmp P0, S1
