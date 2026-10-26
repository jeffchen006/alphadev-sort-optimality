# n=5 model=out iset=I1 prefix14_class=8438
mov S2, P1
mov S0, P3
cmp S2, P0
cmovge P1, P0
cmovl S2, P0
cmp P2, P3
cmovge S0, P2
cmovg P2, P3
mov S1, S2
cmp S0, S1
cmovge S1, S0
cmovg S0, S2
cmp P1, P2
cmovl S1, P1
