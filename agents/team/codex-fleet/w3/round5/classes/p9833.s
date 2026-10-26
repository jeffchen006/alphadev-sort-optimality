# n=5 model=out iset=I1 prefix14_class=9833
cmp P3, P0
cmovge S2, P3
cmovle S2, P0
cmovl P0, P3
mov P3, P1
cmp P1, P2
cmovge P1, P2
cmovge P2, P3
cmp P2, S2
cmovge P3, S2
cmovl P3, P2
cmovl P2, S2
cmp P1, P0
cmovge S2, P1
