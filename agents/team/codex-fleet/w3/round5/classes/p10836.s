# n=5 model=out iset=I1 prefix14_class=10836
mov S0, P2
cmp P1, P3
mov S2, P1
cmovg P1, P3
cmovl S2, P3
cmp P0, S0
cmovge P2, P0
cmovg P0, S0
cmp P2, S2
cmovg S0, P2
cmovge P2, S2
cmovg S2, S0
cmp P0, P1
cmovl S0, P1
