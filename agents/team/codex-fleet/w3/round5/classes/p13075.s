# n=5 model=out iset=I1 prefix14_class=13075
cmp P2, P3
cmovge S2, P2
cmovg P2, P3
cmovge P3, S2
mov S0, P0
cmp P0, P1
cmovge P0, P1
cmovl S0, P1
cmp P0, P2
cmovge P1, P0
mov S1, S0
cmovge P0, P2
cmovge P2, P1
cmp P3, S1
