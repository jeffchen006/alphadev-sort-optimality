# n=5 model=out iset=I1 prefix14_class=11893
mov S2, P3
cmp P1, S2
cmovge S2, P1
cmovge P1, P3
cmp P0, P2
cmovle S1, P0
cmovl P0, P2
cmovle P2, S1
mov P3, P0
cmp P0, S2
cmovg P3, S2
cmovl P0, S2
cmp P2, P1
cmovge S1, P2
