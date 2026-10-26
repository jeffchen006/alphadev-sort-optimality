# n=5 model=out iset=I1 prefix14_class=14401
mov S0, P2
mov S1, P1
cmp P0, P2
cmovle S0, P0
cmovl P0, P2
mov S2, P0
cmp P1, P3
cmovge S1, P3
cmovl P1, P3
cmp S1, S0
cmovle P3, S0
cmovl S0, S1
cmovle S1, P3
mov P2, S1
