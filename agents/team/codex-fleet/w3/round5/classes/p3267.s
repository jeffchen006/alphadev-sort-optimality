# n=5 model=out iset=I1 prefix14_class=3267
mov S1, P0
cmp P2, P1
cmovge S2, P1
cmovg P1, P2
cmovge P2, S2
mov S0, P2
cmp P3, P0
cmovg S1, P3
cmovge P3, P0
cmp P2, P3
cmovl P2, P3
mov P0, P2
cmovge S0, P3
cmp P1, S1
