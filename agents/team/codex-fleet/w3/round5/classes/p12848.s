# n=5 model=out iset=I1 prefix14_class=12848
mov S1, P3
cmp P0, P1
cmovle S2, P1
cmovl P1, P0
mov S0, P1
cmovl P0, S2
cmp S1, P2
cmovl P3, P2
cmovle P2, S1
cmp P1, P2
cmovle S0, P2
cmovle P2, P1
cmp P0, P3
cmovge S1, P3
