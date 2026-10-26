# n=5 model=out iset=I1 prefix14_class=14278
cmp P1, P2
cmovle S1, P2
cmovl P2, P1
cmovle P1, S1
mov S0, P3
cmp P0, S0
cmovge P3, P0
cmovle S0, P0
cmovle P0, P3
cmp P3, P1
cmovle P0, P1
cmovle P1, P3
cmp P2, S0
mov S2, S0
