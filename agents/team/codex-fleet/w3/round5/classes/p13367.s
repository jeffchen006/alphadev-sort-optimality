# n=5 model=out iset=I1 prefix14_class=13367
cmp P2, P3
cmovl S1, P2
cmovl P2, P3
mov S0, P1
cmovl P3, S1
cmp P0, P1
cmovge P1, P0
cmovl S0, P0
cmp S0, P3
cmovge S2, P3
cmovle S2, S0
cmovge P3, S0
cmp P2, P1
mov S2, P2
