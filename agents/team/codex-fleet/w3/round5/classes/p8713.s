# n=5 model=out iset=I1 prefix14_class=8713
cmp P2, P0
cmovge S0, P0
cmovg P0, P2
cmovg P2, S0
mov S1, P3
mov S2, P0
cmp P3, P1
cmovg S1, P1
cmovl P3, P1
cmp P3, S2
cmovg S2, P3
mov S2, S1
cmovl P0, P3
cmovge P3, P0
