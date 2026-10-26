# n=5 model=out iset=I1 prefix14_class=7314
cmp P3, P1
cmovle S1, P1
cmovl P1, P3
cmovge S1, P3
cmp P0, P2
cmovge P3, P0
cmovle P3, P2
cmovg P0, P2
cmp P0, P1
cmovge S2, P0
cmovge P0, P1
cmovg P1, S2
mov P0, S1
cmp P0, P3
