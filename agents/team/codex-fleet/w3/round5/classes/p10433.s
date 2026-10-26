# n=5 model=out iset=I1 prefix14_class=10433
cmp P0, P3
cmovl S2, P3
cmovle P3, P0
cmovl P0, S2
mov S0, P2
cmp S0, P1
mov S1, P0
cmovl P2, P1
cmovge S0, P1
cmp P2, S1
cmovle P0, P2
cmovle P2, S1
cmp P3, S0
cmovle P2, P3
