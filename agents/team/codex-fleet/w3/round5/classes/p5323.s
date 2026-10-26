# n=5 model=out iset=I1 prefix14_class=5323
cmp P0, P1
cmovl S1, P1
cmovge S1, P0
cmovl P1, P0
mov S2, P3
cmp P3, P2
cmovg P3, P2
cmovle S2, P2
cmp P1, P3
cmovle S0, P3
cmovle P3, P1
cmovge S0, P1
cmp S2, S1
mov P3, S2
