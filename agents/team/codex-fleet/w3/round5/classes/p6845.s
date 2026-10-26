# n=5 model=out iset=I1 prefix14_class=6845
cmp P2, P3
cmovl S2, P3
mov S0, P1
cmovle P3, P2
cmovl P2, S2
cmp P0, P1
cmovle P1, P0
cmovl P0, S0
cmp P0, P2
cmovge S1, P2
cmovle S1, P0
cmovge P2, P0
cmp P1, P3
cmovge P0, P1
