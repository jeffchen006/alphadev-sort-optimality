# n=5 model=out iset=I1 prefix14_class=11519
mov S1, P3
cmp P0, P1
cmovle S0, P0
cmovge S0, P1
cmovle P0, P1
cmp P2, S1
cmovle S1, P2
cmovle P2, P3
cmp S0, S1
cmovle P3, S0
cmovle S0, S1
cmovl S1, P3
cmp P0, P2
cmovle S2, P0
