# n=5 model=out iset=I1 prefix14_class=973
mov S0, P3
cmp P1, S0
cmovl P3, P1
cmovg S0, P1
cmp P2, P0
mov S2, S0
cmovge S1, P2
cmovg P2, P0
cmovg P0, S1
cmp P0, S2
cmovge S0, P0
cmovg P0, S2
cmp P2, P3
cmovge P1, P3
