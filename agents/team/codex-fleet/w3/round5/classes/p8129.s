# n=5 model=out iset=I1 prefix14_class=8129
mov S1, P3
cmp P2, S1
cmovl P3, P2
cmovle P2, S1
mov S1, P3
cmp P0, P1
cmovle S0, P1
cmovle P1, P0
cmovle P0, S0
cmp S1, P1
cmovle S1, P1
mov S2, P0
cmovge P3, P1
cmp P2, P0
