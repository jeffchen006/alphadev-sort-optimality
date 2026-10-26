# n=5 model=out iset=I1 prefix14_class=12156
cmp P0, P2
cmovge S1, P2
cmovge P2, P0
cmovge P0, S1
cmp P1, P3
cmovle S0, P3
cmovge S0, P1
cmovge P1, P3
cmp P1, P0
cmovge P3, P1
cmovg P1, P0
cmovge P0, P3
cmp P2, S0
cmovl P3, P2
