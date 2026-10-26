# n=5 model=out iset=I1 prefix14_class=11775
cmp P3, P0
cmovg S0, P0
cmovge P0, P3
cmovg P3, S0
mov S1, P2
cmp P1, P2
cmovg S1, P1
cmovl P2, P1
cmp P0, S1
cmovge S0, S1
cmovge S1, P0
cmovge P0, S0
cmp P2, P3
cmovl S1, P3
