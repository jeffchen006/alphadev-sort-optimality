# n=5 model=out iset=I1 prefix14_class=121
cmp P0, P3
cmovle S2, P3
cmovge S2, P0
cmovg P0, P3
mov P3, P1
cmp P2, P3
cmovge P3, P2
cmovle P1, P2
cmp P1, P0
mov S1, P0
cmovle P0, P1
cmovl P1, S1
cmp P3, S2
cmovle P2, S2
