# n=5 model=out iset=I1 prefix14_class=6393
cmp P1, P0
cmovg S2, P1
cmovge P1, P0
cmovg P0, S2
mov S2, P2
cmp P3, S2
cmovl P2, P3
cmovl P3, S2
cmp P3, P0
cmovle S1, P3
cmovge S1, P0
cmovge P0, P3
cmp P1, P2
cmovl S2, P1
