# n=5 model=out iset=I1 prefix14_class=1587
cmp P3, P2
mov S0, P0
cmovg S1, P3
cmovge P3, P2
cmovg P2, S1
cmp P1, S0
cmovge S0, P1
cmovl P0, P1
cmp P3, P0
mov S1, P3
cmovl P3, P0
mov S2, S0
cmovg S1, P0
cmp P2, S2
