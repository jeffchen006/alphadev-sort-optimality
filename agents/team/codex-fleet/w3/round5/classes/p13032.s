# n=5 model=out iset=I1 prefix14_class=13032
mov S0, P0
cmp P1, P0
cmovge S0, P1
cmovl P0, P1
mov P1, P2
cmp P1, P3
cmovl P1, P3
cmovle P3, P2
cmp P3, P0
cmovle S1, P3
cmovl P3, P0
cmovl P0, S1
cmp S0, P1
cmovle S2, P1
