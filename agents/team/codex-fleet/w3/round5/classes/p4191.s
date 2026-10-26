# n=5 model=out iset=I1 prefix14_class=4191
cmp P0, P1
mov S1, P0
cmovge P0, P1
cmovle S1, P1
cmp P2, P3
cmovle P1, P2
cmovl P2, P3
cmovl P3, P1
cmp P3, P0
cmovge S0, P3
cmovle S0, P0
cmovle P0, P3
cmp S1, P2
mov P3, S1
