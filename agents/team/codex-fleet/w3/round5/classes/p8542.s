# n=5 model=out iset=I1 prefix14_class=8542
cmp P2, P0
cmovle S2, P2
cmovl P2, P0
cmovle P0, S2
cmp P3, P1
mov S1, P3
cmovle S1, P1
cmovl P1, P3
cmovl P3, S1
cmp P2, S1
cmovle S1, P2
cmovg P3, P2
cmp P1, P0
cmovge P2, P1
