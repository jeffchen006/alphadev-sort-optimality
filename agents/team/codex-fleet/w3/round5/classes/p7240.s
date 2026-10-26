# n=5 model=out iset=I1 prefix14_class=7240
cmp P1, P0
cmovle S2, P0
cmovge S2, P1
cmovl P0, P1
cmp P3, P2
mov S0, P0
cmovle P1, P2
cmovl P2, P3
cmovge P1, P3
cmp P2, P0
cmovle P0, P2
cmovge S0, P2
cmp S2, P1
cmovle P3, P1
