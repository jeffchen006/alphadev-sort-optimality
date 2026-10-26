# n=5 model=out iset=I1 prefix14_class=966
cmp P1, P3
mov S0, P3
cmovl P3, P1
cmovg S0, P1
cmp P0, P2
mov S2, S0
cmovg S1, P0
cmovg P0, P2
cmovg P2, S1
cmp P2, S2
cmovge S0, P2
cmovg P2, S2
cmp P0, P3
cmovg S2, P3
