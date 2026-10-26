# n=5 model=out iset=I1 prefix14_class=5076
mov S2, P1
cmp S2, P2
cmovl P1, P2
cmovl P2, S2
mov S0, P0
cmp S0, P3
mov S1, P2
cmovg P0, P3
cmovge P3, S0
cmp S1, P0
cmovge S1, P0
cmovge P0, P2
cmp P3, P1
cmovg S1, P1
