# n=5 model=out iset=I1 prefix14_class=975
mov S0, P3
cmp P1, S0
cmovg S0, P1
cmovl P3, P1
cmovge P1, P3
cmp P0, P2
mov S2, S0
cmovge S1, P0
cmovge P0, P2
cmovg P2, S1
cmp P2, S2
cmovge S0, P2
cmovge P2, S2
cmp P0, P3
