# n=5 model=out iset=I1 prefix14_class=13417
cmp P3, P0
cmovge S2, P3
mov S1, P2
cmovge P3, P0
cmovge P0, S2
cmp P1, S1
cmovl S1, P1
cmovg P2, P1
mov P1, P3
cmp P1, S1
cmovl P3, S1
cmovle S1, P1
cmp P0, P2
cmovge P1, P0
