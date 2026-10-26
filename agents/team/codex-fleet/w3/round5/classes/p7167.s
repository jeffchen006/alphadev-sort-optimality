# n=5 model=out iset=I1 prefix14_class=7167
cmp P2, P0
mov S2, P2
cmovle S2, P0
cmovge P2, P0
mov S0, P2
cmp P3, P1
cmovle S1, P1
cmovle P1, P3
cmovl P3, S1
cmp P2, P1
cmovle S0, P1
cmovge P2, P1
mov P1, P3
cmp P3, S2
