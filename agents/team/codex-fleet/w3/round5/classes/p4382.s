# n=5 model=out iset=I1 prefix14_class=4382
mov S2, P3
mov S1, P2
cmp P0, P2
cmovl P2, P0
cmovl P0, S1
cmovle S1, P2
cmp P1, P3
cmovle P3, P1
cmovge S2, P1
cmp P2, P3
cmovl S1, P3
cmovge P2, P3
cmp P0, S2
cmovl P2, S2
