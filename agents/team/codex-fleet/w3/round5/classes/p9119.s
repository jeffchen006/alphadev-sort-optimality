# n=5 model=out iset=I1 prefix14_class=9119
mov S0, P2
cmp P2, P1
cmovl P2, P1
cmovg S0, P1
cmp P3, P0
cmovge S1, P3
cmovge P3, P0
cmovg P0, S1
mov S2, S0
cmp P3, S0
cmovl S0, P3
cmovg S2, P3
cmp P2, P0
cmovge S1, P2
