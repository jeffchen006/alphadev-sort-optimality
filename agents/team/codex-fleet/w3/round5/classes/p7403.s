# n=5 model=out iset=I1 prefix14_class=7403
mov S0, P3
cmp P1, P2
cmovl S2, P1
cmovl P1, P2
cmovl P2, S2
mov S1, P2
cmp S0, P0
cmovg S0, P0
cmovge P0, P3
cmp S0, P2
cmovge P2, S0
cmovg S0, S1
cmp P0, P1
cmovl S2, P1
