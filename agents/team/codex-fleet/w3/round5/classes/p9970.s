# n=5 model=out iset=I1 prefix14_class=9970
cmp P1, P0
mov S2, P1
cmovg S2, P0
cmovg P0, P1
cmp P2, P3
cmovge S0, P2
cmovg P2, P3
cmovg P3, S0
cmp P3, P0
cmovge S0, P3
cmovg P3, P0
cmovg P0, S0
cmp P2, S2
cmovl S1, P2
