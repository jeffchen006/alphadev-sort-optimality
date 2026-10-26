# n=5 model=out iset=I1 prefix14_class=8759
mov S2, P1
cmp P3, P1
cmovl S2, P3
cmovl P3, P1
cmp P2, P0
cmovle S1, P0
cmovl P0, P2
cmovge S1, P2
cmp P3, S1
cmovge P2, P3
cmovge P3, S1
cmovge S1, P2
cmp P0, S2
cmovge P2, P0
