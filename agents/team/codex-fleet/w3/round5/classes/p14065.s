# n=5 model=out iset=I1 prefix14_class=14065
cmp P0, P2
cmovle S0, P0
mov S1, P3
cmovle P0, P2
cmovl P2, S0
mov S2, P0
cmp P1, P3
cmovle P3, P1
cmovle P1, S1
cmp P0, P1
cmovle S2, P1
cmovge P0, P1
cmp P3, P2
cmovle P1, P2
