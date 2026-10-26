# n=5 model=out iset=I1 prefix14_class=4257
mov S1, P0
mov S0, P1
cmp P2, P0
cmovl S1, P2
cmovg P0, P2
cmp P3, S0
cmovg P1, P3
cmovge P3, S0
cmp P3, S1
mov S0, S1
cmovl S1, P3
cmovge S0, P3
cmp P0, P1
cmovge P3, S0
