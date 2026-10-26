# n=5 model=out iset=I1 prefix14_class=6911
mov S0, P0
cmp P3, S0
mov S2, P2
cmovl P0, P3
cmovl P3, S0
cmp S2, P1
cmovge S2, P1
cmovle P2, P1
cmp P2, P3
cmovle S1, P3
cmovl P3, P2
mov S0, P0
cmovle P2, S1
cmp S2, S0
