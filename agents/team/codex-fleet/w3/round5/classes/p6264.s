# n=5 model=out iset=I1 prefix14_class=6264
cmp P1, P0
cmovl S2, P0
cmovle P0, P1
mov S0, P2
cmovl P1, S2
cmp P3, P2
cmovge S0, P3
mov S1, P1
cmovle P2, P3
cmp S0, P1
cmovle S1, S0
cmovle S0, P1
cmp P2, P0
cmovge S0, P2
