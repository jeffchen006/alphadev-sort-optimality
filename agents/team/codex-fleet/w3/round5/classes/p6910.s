# n=5 model=out iset=I1 prefix14_class=6910
mov S0, P0
cmp P3, S0
cmovl P0, P3
mov S2, P2
cmovle P3, S0
cmp S2, P1
cmovge S2, P1
cmovl P2, P1
cmp P2, P3
cmovle S1, P3
mov P1, P0
cmovle P3, P2
cmovle P2, S1
cmp S2, P1
