# n=5 model=out iset=I1 prefix14_class=1685
cmp P3, P0
cmovge S1, P3
cmovle S1, P0
cmovle P0, P3
cmp P2, P1
cmovl P3, P2
cmovge P3, P1
cmovl P2, P1
cmovl P1, P3
cmp P0, P3
cmovg P3, P0
mov S2, P2
cmovle P1, P0
mov P1, P3
