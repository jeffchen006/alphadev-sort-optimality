# n=5 model=out iset=I1 prefix14_class=4563
mov S0, P3
mov S2, P0
cmp P2, P3
cmovge P3, P2
cmovl S0, P2
cmp P1, S2
cmovge P0, P1
cmovge P1, S2
cmovge S2, P0
cmp P3, P0
cmovg S2, P3
cmovl P0, P3
cmp P1, S0
cmovge S2, P1
