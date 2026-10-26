# n=5 model=out iset=I1 prefix14_class=8450
cmp P3, P1
cmovge S0, P3
mov S1, P2
cmovl S0, P1
cmovge P3, P1
cmp P0, P2
cmovge P2, P0
cmovge P0, S1
mov S1, P3
cmp S0, P2
cmovge P1, P2
cmovge P2, S0
cmovg S0, P1
cmp P3, P0
