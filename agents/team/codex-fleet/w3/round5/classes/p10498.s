# n=5 model=out iset=I1 prefix14_class=10498
mov S1, P1
mov S2, P2
cmp P3, S1
cmovle P1, P3
cmovl P3, S1
cmp P0, P2
cmovge S2, P0
cmovle P2, P0
cmp S2, P3
cmovle S0, P3
cmovl P3, S2
mov P0, P2
cmovle S2, S0
cmp P1, P0
