# n=5 model=out iset=I1 prefix14_class=9452
cmp P0, P1
mov S1, P0
cmovl P0, P1
mov S2, P3
cmovg S1, P1
cmp P3, P2
cmovge P3, P2
mov S0, S1
cmovl S2, P2
cmp P3, S1
cmovge S0, P3
cmovl S1, P3
cmp P0, S2
cmovg S1, S2
