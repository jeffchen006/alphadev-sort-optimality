# n=5 model=out iset=I1 prefix14_class=12527
cmp P3, P2
mov S0, P0
cmovle S1, P3
cmovl P3, P2
cmovl P2, S1
cmp P0, P1
mov S2, P2
cmovge P0, P1
cmovg P1, S0
cmp P0, P2
cmovge S2, P0
cmovg P0, P2
cmp P1, P3
cmovle P0, P1
