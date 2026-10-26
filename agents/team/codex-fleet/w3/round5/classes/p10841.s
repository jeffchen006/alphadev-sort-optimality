# n=5 model=out iset=I1 prefix14_class=10841
cmp P2, P0
mov S1, P1
mov S2, P2
cmovg P2, P0
cmovge P0, S2
cmp S1, P3
cmovge S1, P3
cmovl P1, P3
cmp P1, P0
cmovge P3, P0
cmovg P0, P1
cmovg P1, P3
mov S0, S1
cmp S1, P2
