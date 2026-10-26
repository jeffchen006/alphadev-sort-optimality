# n=5 model=out iset=I1 prefix14_class=2119
cmp P3, P0
cmovge S2, P0
cmovle S2, P3
cmovge P0, P3
mov P3, P1
cmp P3, P2
cmovl P3, P2
cmovge P1, P2
cmovg P2, P3
cmp P3, P0
cmovle P2, P0
cmovg P3, P0
cmp P1, S2
cmovle P2, P1
