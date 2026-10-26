# n=5 model=out iset=I1 prefix14_class=6069
cmp P2, P0
cmovl S1, P0
cmovge S1, P2
mov S0, P3
cmovle P0, P2
cmp P3, P1
cmovle P3, P1
cmovl P1, S0
cmovle S0, P3
cmp S1, P3
cmovl P3, S1
cmovl S1, S0
cmp P0, P1
cmovle S0, P1
