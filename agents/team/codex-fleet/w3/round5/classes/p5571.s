# n=5 model=out iset=I1 prefix14_class=5571
mov S1, P1
cmp P3, S1
mov S0, P0
cmovge S1, P3
cmovge P3, P1
cmp P0, P2
cmovl P0, P2
mov S2, P3
cmovl P2, S0
cmp P2, P3
cmovl P3, P2
cmovg S2, P2
cmp P0, S1
cmovl P1, P0
