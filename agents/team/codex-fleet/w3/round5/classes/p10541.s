# n=5 model=out iset=I1 prefix14_class=10541
cmp P1, P2
mov S1, P0
mov S0, P1
cmovle P1, P2
cmovle P2, S0
cmp P3, S1
cmovge S1, P3
cmovle P0, P3
cmp S1, P1
cmovl S0, S1
cmovle S1, P1
cmovl P1, S0
cmp P2, P0
mov S1, P0
