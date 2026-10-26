# n=5 model=out iset=I1 prefix14_class=8673
cmp P1, P3
mov S0, P3
cmovge S0, P1
cmovge P1, P3
cmp P2, P0
mov S1, S0
cmovl P3, P0
cmovl P0, P2
cmovl P2, P3
cmp P2, S0
cmovg S1, P2
cmovge P2, S0
cmp P0, P1
cmovge S1, P1
