# n=5 model=out iset=I1 prefix14_class=7912
cmp P1, P3
cmovl S2, P1
cmovle P1, P3
cmovl P3, S2
mov S1, P0
cmp P2, P0
cmovle S1, P2
cmovg P0, P2
cmovge P2, S1
cmp P3, S1
cmovge S1, P3
cmovle P2, P3
cmp P0, P1
cmovle P2, P0
