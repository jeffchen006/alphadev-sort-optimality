# n=5 model=out iset=I1 prefix14_class=2432
mov S2, P0
cmp P3, S2
cmovl S2, P3
cmovge P0, P3
cmp P1, P2
mov S0, P1
mov S1, P0
cmovl P1, P2
cmovl P2, S0
cmp P1, S1
cmovge P0, P1
cmovge P1, S1
mov P0, S2
cmp P2, S2
