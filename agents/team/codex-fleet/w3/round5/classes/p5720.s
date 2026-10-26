# n=5 model=out iset=I1 prefix14_class=5720
mov S2, P1
mov S0, P2
cmp P3, P2
cmovg P2, P3
cmovl S0, P3
cmp P0, S2
cmovge P1, P0
cmovge P0, S2
cmp P0, S0
cmovge S1, P0
cmovg P0, S0
cmovg S0, S1
cmp P2, P1
cmovl S2, P2
