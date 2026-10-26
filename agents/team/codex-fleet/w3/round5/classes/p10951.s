# n=5 model=out iset=I1 prefix14_class=10951
cmp P2, P3
cmovle S2, P3
cmovl P3, P2
cmovle P2, S2
cmp P1, P0
cmovge S1, P1
cmovge P1, P0
mov S2, P2
cmovg P0, S1
cmp P0, P2
cmovg P2, P0
cmovl S2, P0
cmp P3, P1
cmovle P0, P1
