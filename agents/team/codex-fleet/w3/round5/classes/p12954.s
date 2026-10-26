# n=5 model=out iset=I1 prefix14_class=12954
cmp P1, P0
cmovge S0, P0
mov S1, P2
cmovge P0, P1
cmovg P1, S0
cmp P3, S1
cmovge S1, P3
cmovl P2, P3
mov S2, P2
cmp P1, S2
cmovg S2, P1
cmovg P1, P2
cmp S1, P0
cmovge P1, S1
