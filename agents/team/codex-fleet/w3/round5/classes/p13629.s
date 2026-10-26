# n=5 model=out iset=I1 prefix14_class=13629
cmp P2, P1
cmovge S2, P2
cmovl S2, P1
cmovl P1, P2
cmp P3, P0
cmovge S1, P3
cmovle S1, P0
cmovge P3, P0
cmp P1, P3
cmovge P2, P3
cmovge P3, P1
cmovge P1, P2
cmp S2, S1
cmovge P1, S1
