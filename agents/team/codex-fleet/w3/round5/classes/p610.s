# n=5 model=out iset=I1 prefix14_class=610
cmp P3, P2
mov S0, P0
mov S2, P3
cmovg P3, P2
cmovl S2, P2
cmp P0, P1
cmovge P0, P1
cmovg P1, S0
mov S0, S2
mov S1, P3
cmp P1, S0
cmovge S2, P1
cmovl S0, P1
cmp P0, S1
