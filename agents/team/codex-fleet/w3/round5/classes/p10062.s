# n=5 model=out iset=I1 prefix14_class=10062
cmp P0, P3
mov S1, P1
cmovle S2, P0
cmovle P0, P3
cmovle P3, S2
cmp P2, S1
cmovle P1, P2
cmovl P2, S1
cmovge S1, P2
cmp P0, P2
cmovge P2, P0
cmovge P0, S1
cmp P3, P1
cmovle P2, P1
