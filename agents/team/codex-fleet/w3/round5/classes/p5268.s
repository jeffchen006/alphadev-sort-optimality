# n=5 model=out iset=I1 prefix14_class=5268
cmp P3, P0
cmovle S1, P3
cmovg S1, P0
mov S2, P1
cmovg P0, P3
cmovge P3, S1
cmp P2, S2
cmovge S2, P2
cmovl P1, P2
cmp S1, P1
cmovge P3, P1
cmovl S1, P1
cmp S2, P0
cmovl P1, S1
