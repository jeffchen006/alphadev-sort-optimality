# n=5 model=out iset=I1 prefix14_class=2042
cmp P0, P1
mov S2, P1
cmovge P1, P0
cmovl S2, P0
cmovge P0, S2
cmp P2, P3
cmovge S1, P2
cmovge P2, P3
cmovge P3, S1
mov S0, P3
cmp S0, P1
cmovge P3, P1
cmovle S0, P1
cmovl P1, P3
