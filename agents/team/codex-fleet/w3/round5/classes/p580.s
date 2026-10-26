# n=5 model=out iset=I1 prefix14_class=580
cmp P3, P0
cmovl S2, P0
cmovge S2, P3
cmovge P3, P0
mov P0, S2
cmp P2, P1
cmovge S0, P2
cmovge P2, P1
cmovg P1, S0
cmp P1, S2
mov S1, P3
cmovge P0, P1
cmovl S2, P1
cmp P2, S1
