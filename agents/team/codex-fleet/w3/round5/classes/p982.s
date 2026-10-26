# n=5 model=out iset=I1 prefix14_class=982
cmp P0, P1
mov S0, P3
cmovge S2, P0
cmovl S2, P1
cmovl P1, P0
cmp S0, P2
cmovge P3, P2
cmovge P2, S0
cmp S2, P2
mov S0, P2
cmovge P2, S2
cmovg S2, S0
cmp P3, P1
cmovge S1, P1
