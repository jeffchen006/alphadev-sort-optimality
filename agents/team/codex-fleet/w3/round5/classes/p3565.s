# n=5 model=out iset=I1 prefix14_class=3565
mov S1, P0
cmp P0, P2
cmovl P0, P2
mov S2, P1
mov S0, P0
cmovl P2, S1
cmp P3, S2
cmovge S2, P3
cmovl P1, P3
cmp P2, P1
cmovge S1, P2
cmovg P2, P1
cmovge P1, S1
cmp S2, P0
