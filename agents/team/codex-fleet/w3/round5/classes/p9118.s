# n=5 model=out iset=I1 prefix14_class=9118
mov S0, P3
cmp P3, P1
cmovl P3, P1
cmovg S0, P1
cmp P2, P0
cmovge S1, P2
cmovge P2, P0
cmovg P0, S1
mov S2, S0
cmp P2, S0
cmovl S0, P2
cmovg S2, P2
cmp P3, P0
cmovge S1, P3
