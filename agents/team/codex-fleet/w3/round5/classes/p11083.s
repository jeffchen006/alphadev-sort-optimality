# n=5 model=out iset=I1 prefix14_class=11083
cmp P3, P0
cmovge S0, P3
cmovle S0, P0
cmovle P0, P3
mov S2, P2
cmp P2, P1
cmovl S2, P1
cmovle P1, P2
cmp S2, S0
cmovl P2, S0
cmovle S0, S2
cmovl S2, P2
mov S1, P1
cmp S1, P0
