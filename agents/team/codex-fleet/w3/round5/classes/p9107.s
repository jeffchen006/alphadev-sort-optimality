# n=5 model=out iset=I1 prefix14_class=9107
cmp P1, P2
cmovl S1, P1
cmovge S1, P2
cmovl P1, P2
cmovl P2, S1
cmp P3, P0
cmovge S2, P3
cmovg P3, P0
cmovge P0, S2
cmp P3, S1
cmovl S1, P3
cmovge P2, P3
cmp P1, P0
cmovle S2, P0
