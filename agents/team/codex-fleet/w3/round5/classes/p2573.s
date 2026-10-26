# n=5 model=out iset=I1 prefix14_class=2573
mov S0, P2
cmp P2, P1
cmovge S0, P1
cmovg P1, P2
mov S2, P3
cmp P0, S2
cmovge P3, P0
cmovg P0, S2
cmp P3, P1
cmovge P2, P3
cmovl P2, P1
cmovg P3, P1
cmp P0, S0
cmovge S2, P0
