# n=5 model=out iset=I1 prefix14_class=8178
cmp P3, P1
cmovl S0, P3
cmovle P3, P1
cmovl P1, S0
cmp P2, P0
cmovle S1, P2
cmovl P2, P0
cmovge S1, P0
cmp P1, S1
mov P0, P1
cmovge P1, S1
cmovg S1, P0
cmp P3, P2
mov S2, P3
