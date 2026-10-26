# n=5 model=out iset=I1 prefix14_class=6485
mov S0, P3
mov S1, P0
cmp S1, P1
cmovl S1, P1
cmovl P1, P0
cmp P2, S0
cmovge S0, P2
cmovle P3, P2
cmp S1, S0
cmovle P0, S1
cmovg P0, S0
cmovle S1, S0
cmp P1, P3
cmovle S0, P1
