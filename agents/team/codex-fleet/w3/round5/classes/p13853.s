# n=5 model=out iset=I1 prefix14_class=13853
mov S1, P3
mov S2, P2
cmp S2, P1
cmovge S2, P1
cmovl P2, P1
cmp P0, S1
cmovge S1, P0
cmovl P3, P0
cmp P2, S1
cmovle S0, S1
cmovle S1, P2
cmovle P2, S0
mov P2, S2
cmp P3, S2
