# n=5 model=out iset=I1 prefix14_class=14348
mov S2, P1
cmp S2, P0
cmovl P1, P0
cmovl P0, S2
cmp P2, P3
cmovle S1, P2
cmovle P2, P3
cmovle P3, S1
cmp P3, P0
cmovl S0, P3
cmovge S0, P0
cmovge P0, P3
mov S0, P2
cmp P1, S0
