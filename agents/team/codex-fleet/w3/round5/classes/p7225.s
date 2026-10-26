# n=5 model=out iset=I1 prefix14_class=7225
cmp P1, P2
cmovge S2, P1
cmovge P1, P2
cmovle S2, P2
cmp P0, P3
cmovge P2, P3
mov S0, S2
cmovge P3, P0
cmovge P0, P2
cmp P0, P1
cmovl S1, P1
cmovl P1, P0
cmovl P0, S1
cmp P3, S0
