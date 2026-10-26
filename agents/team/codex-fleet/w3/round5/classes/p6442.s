# n=5 model=out iset=I1 prefix14_class=6442
cmp P1, P2
mov S1, P0
mov S2, P2
cmovge P2, P1
cmovl S2, P1
cmp P3, S1
cmovge P0, P3
mov S0, P2
cmovl S1, P3
cmp P0, S0
cmovge P2, P0
cmovl S0, P0
cmp S2, S1
cmovl P0, S1
