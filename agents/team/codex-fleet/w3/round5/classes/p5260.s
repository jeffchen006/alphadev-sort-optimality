# n=5 model=out iset=I1 prefix14_class=5260
mov S0, P1
cmp S0, P3
cmovg P1, P3
cmovle S0, P3
mov S2, P2
cmp P0, S2
cmovl P2, P0
cmovle P0, S2
cmp P2, P1
cmovge S1, P1
cmovg P1, P2
cmovg P2, S1
mov P3, P0
cmp P3, S0
