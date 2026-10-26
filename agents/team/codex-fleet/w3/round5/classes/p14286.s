# n=5 model=out iset=I1 prefix14_class=14286
mov S0, P3
mov S1, P2
cmp P1, P2
cmovl P2, P1
cmovl P1, S1
cmp P0, S0
cmovge P3, P0
cmovg P0, S0
cmp P1, P3
cmovge S2, P3
cmovl S2, P1
cmovge P3, P1
cmovg S1, P2
cmp P2, P0
