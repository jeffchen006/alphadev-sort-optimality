# n=5 model=out iset=I1 prefix14_class=8121
mov S1, P3
cmp P0, P3
cmovle P3, P0
cmovle P0, S1
cmp P2, P1
cmovle S0, P1
mov S1, P3
cmovle P1, P2
cmovl P2, S0
cmp S1, P1
cmovge P3, P1
cmovle S1, P1
cmp P2, P0
cmovge P1, P2
