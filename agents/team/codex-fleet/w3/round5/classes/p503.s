# n=5 model=out iset=I1 prefix14_class=503
cmp P3, P0
cmovge S1, P0
cmovge P0, P3
mov S0, P1
cmovl S1, P3
cmp P1, P2
cmovge P1, P2
cmovge P2, S0
mov S2, P1
cmp S1, P1
cmovl P1, S1
cmovle S1, S2
cmp P0, P2
mov S2, P0
