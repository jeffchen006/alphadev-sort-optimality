# n=5 model=out iset=I1 prefix14_class=629
mov S0, P3
cmp P3, P2
cmovl S0, P2
mov S1, P1
cmovge P3, P2
cmp P1, P0
cmovg S1, P0
cmovg P0, P1
cmp P0, S0
mov S2, S0
cmovge S2, P0
cmovl S0, P0
mov P2, P3
mov S2, S0
