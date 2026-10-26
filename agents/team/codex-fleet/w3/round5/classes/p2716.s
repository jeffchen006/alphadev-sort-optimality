# n=5 model=out iset=I1 prefix14_class=2716
cmp P3, P2
cmovge S0, P3
cmovl S0, P2
cmovl P2, P3
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
cmovl P1, S1
cmp S0, P0
mov S2, P0
cmovle P0, S0
cmovle S0, S2
mov S0, P2
cmp P1, S0
