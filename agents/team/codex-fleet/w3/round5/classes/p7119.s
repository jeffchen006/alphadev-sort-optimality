# n=5 model=out iset=I1 prefix14_class=7119
cmp P3, P0
cmovle S2, P0
mov S1, P2
cmovle P0, P3
cmovle P3, S2
cmp P2, P1
cmovle S1, P1
cmovl P1, P2
cmp P1, P0
cmovge P2, P1
cmovg P1, P0
cmovle P2, P0
cmp P3, S1
cmovge S0, S1
