# n=5 model=out iset=I1 prefix14_class=7624
cmp P3, P2
cmovle S2, P2
cmovge S2, P3
cmovle P2, P3
cmp P1, P0
mov P3, P1
cmovg P3, P0
cmovg P0, P1
cmp P3, P2
cmovl P1, P2
cmovl P2, P3
cmovl P3, P1
cmp P0, S2
cmovle P2, S2
