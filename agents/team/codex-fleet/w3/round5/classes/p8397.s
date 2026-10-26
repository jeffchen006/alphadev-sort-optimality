# n=5 model=out iset=I1 prefix14_class=8397
cmp P1, P0
mov S1, P0
cmovg S1, P1
cmovl P0, P1
cmp P2, P3
mov S0, S1
cmovl S2, P3
cmovge S2, P2
cmovge P2, P3
cmp S1, S2
cmovl S0, S2
cmovge S1, S2
cmp P2, P0
cmovle S0, P0
