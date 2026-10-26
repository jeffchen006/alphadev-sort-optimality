# n=5 model=out iset=I1 prefix14_class=1497
mov S0, P0
mov S2, P1
cmp P1, P2
cmovl S2, P2
cmovge P1, P2
cmp S0, P3
cmovl S0, P3
cmovl P3, P0
cmp S0, S2
cmovge P0, S2
cmovg S2, S0
cmovg S0, P0
mov S2, S0
mov P2, P1
