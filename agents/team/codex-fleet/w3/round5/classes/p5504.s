# n=5 model=out iset=I1 prefix14_class=5504
mov S2, P0
cmp P2, P3
mov S0, P2
cmovl P2, P3
cmovl P3, S0
cmp S2, P1
cmovge S2, P1
mov S1, P3
cmovle P0, P1
cmp S1, S2
cmovle S1, S2
cmovle S2, P3
cmp P2, P0
cmovl P3, P2
