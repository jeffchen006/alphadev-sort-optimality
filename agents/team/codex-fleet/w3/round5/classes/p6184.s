# n=5 model=out iset=I1 prefix14_class=6184
mov S0, P2
cmp P3, S0
cmovle P2, P3
cmovle P3, S0
mov S2, P1
cmp P0, S2
cmovle P1, P0
cmovge S2, P0
cmp S2, P3
cmovl S0, S2
cmovle S2, P3
cmovl P3, S0
mov S1, P1
cmp S1, P2
