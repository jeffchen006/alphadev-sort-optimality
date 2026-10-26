# n=5 model=out iset=I1 prefix14_class=9088
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
cmovl P1, S1
cmp P3, P2
mov S2, P3
cmovg P3, P2
cmovl S2, P2
cmp P3, P1
cmovge P2, P3
cmovge P3, P1
cmovle P2, P1
cmp P0, S2
cmovge P3, P0
