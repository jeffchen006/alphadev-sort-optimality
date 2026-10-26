# n=5 model=out iset=I1 prefix14_class=6585
mov S2, P2
cmp P3, S2
cmovle S2, P3
cmovl P3, P2
cmovge P2, P3
cmp P1, P0
cmovle S1, P1
cmovl P1, P0
cmovle P0, S1
cmp P2, P1
cmovl P3, P1
cmovl P1, P2
mov S0, S2
cmp P0, S0
