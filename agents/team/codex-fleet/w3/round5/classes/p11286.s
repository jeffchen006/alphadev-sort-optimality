# n=5 model=out iset=I1 prefix14_class=11286
mov S1, P2
cmp P0, S1
cmovle S1, P0
cmovl P0, P2
cmp P1, P3
cmovle P2, P3
cmovge P2, P1
cmovge P1, P3
cmp P0, P2
cmovle S0, P2
cmovle P2, P0
cmovl P0, S0
cmp P1, S1
mov S2, P2
