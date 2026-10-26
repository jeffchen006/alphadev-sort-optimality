# n=5 model=out iset=I1 prefix14_class=11824
cmp P3, P0
mov S1, P3
cmovle P3, P0
cmovl P0, S1
mov S1, P2
cmp P2, P1
cmovle P2, P1
cmovle P1, S1
cmp P3, P2
cmovge S1, P3
cmovge P3, P2
cmovle S1, P2
cmp P0, P1
cmovg P2, P0
