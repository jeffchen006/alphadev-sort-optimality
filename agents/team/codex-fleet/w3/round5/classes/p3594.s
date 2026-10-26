# n=5 model=out iset=I1 prefix14_class=3594
mov S1, P3
cmp S1, P1
mov S0, P0
cmovle S1, P1
cmovl P1, P3
cmp P2, P0
cmovle P0, P2
cmovle P2, S0
cmp P0, P1
cmovl P3, P1
cmovl P1, P0
cmovl P0, P3
cmp P2, S1
cmovge P3, P2
