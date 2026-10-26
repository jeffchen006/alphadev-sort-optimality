# n=5 model=out iset=I1 prefix14_class=11261
cmp P1, P3
mov S0, P3
cmovg S0, P1
cmovge P1, P3
cmp P2, P0
cmovge P3, P0
cmovg P0, P2
cmovg P2, P3
cmp P0, S0
mov S2, P1
mov S1, S0
cmovl S0, P0
cmovge S1, P0
cmovge P0, S0
