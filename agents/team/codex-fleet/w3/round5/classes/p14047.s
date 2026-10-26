# n=5 model=out iset=I1 prefix14_class=14047
cmp P1, P2
mov S0, P3
mov S2, P1
cmovge S2, P2
cmovg P2, P1
cmp S0, P0
cmovge S0, P0
cmovge P0, P3
cmp P2, P0
cmovg S1, P2
cmovg P2, P0
cmovg P0, S1
cmp S0, S2
cmovl P0, S0
