# n=5 model=out iset=I1 prefix14_class=12765
mov S1, P1
cmp P1, P2
cmovge P1, P2
cmovle S1, P2
cmp P0, P3
cmovle P2, P3
cmovl P3, P0
mov S2, P3
cmovle P0, P2
cmp P1, S2
cmovge P3, P1
cmovg P1, S2
cmp P0, S1
cmovle S2, S1
