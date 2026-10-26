# n=5 model=out iset=I1 prefix14_class=11138
cmp P3, P0
cmovle S1, P3
cmovl P3, P0
cmovl P0, S1
cmp P1, P2
cmovge S2, P1
cmovle S2, P2
cmovge P1, P2
cmp P3, S2
mov P2, P3
cmovl P3, S2
cmovl S2, P2
mov P3, P1
cmovg P2, S2
