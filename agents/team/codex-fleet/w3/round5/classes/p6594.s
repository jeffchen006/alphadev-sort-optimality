# n=5 model=out iset=I1 prefix14_class=6594
mov S2, P2
cmp P2, P1
cmovle P2, P1
cmovl P1, S2
mov S2, P3
cmp P3, P0
cmovle S2, P0
cmovle P0, P3
cmp P2, S2
cmovge S1, P2
cmovge P2, S2
mov P3, P0
cmovge S2, S1
cmp P0, P1
