# n=5 model=out iset=I1 prefix14_class=6170
cmp P2, P0
mov S0, P2
cmovge S0, P0
cmovl P2, P0
cmp P1, P3
mov S2, P3
cmovl P3, P1
cmovge S2, P1
cmp S2, P2
cmovge P0, P2
cmovge P2, S2
cmovg S2, P0
cmp P3, S0
cmovge P1, S0
