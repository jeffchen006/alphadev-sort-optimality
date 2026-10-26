# n=5 model=out iset=I1 prefix14_class=11143
cmp P3, P1
mov S0, P0
cmovle S1, P3
cmovle P3, P1
cmovl P1, S1
cmp S0, P2
cmovle P0, P2
cmovge S0, P2
cmp P3, P0
cmovl P2, P3
cmovle P3, P0
cmovl P0, P2
mov S2, P1
mov P3, P0
