# n=5 model=out iset=I1 prefix14_class=7611
cmp P0, P1
cmovl S0, P0
cmovl P0, P1
cmovl P1, S0
cmp P2, P3
mov S1, P3
cmovle S1, P2
cmovge P3, P2
mov S2, S1
cmp P1, S1
cmovl S2, P1
cmovg S1, P1
cmp P3, P0
cmovge S2, P0
