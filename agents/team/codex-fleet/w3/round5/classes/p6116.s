# n=5 model=out iset=I1 prefix14_class=6116
cmp P3, P2
cmovge S1, P3
cmovle S1, P2
cmovl P2, P3
mov P3, P1
cmp P0, P3
cmovge P1, P0
cmovg P0, P3
cmovg P3, P1
cmp P3, S1
cmovge P3, S1
cmovge S1, P1
cmp P0, P2
cmovl S2, P0
