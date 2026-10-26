# n=5 model=out iset=I1 prefix14_class=6787
cmp P3, P1
mov S0, P2
mov S2, P1
cmovl P1, P3
cmovge S2, P3
cmp S0, P0
cmovl P2, P0
cmovg S0, P0
cmp S2, P2
cmovge P0, S2
cmovg S2, P2
cmovge P2, P0
cmp S0, P1
cmovge P2, P1
