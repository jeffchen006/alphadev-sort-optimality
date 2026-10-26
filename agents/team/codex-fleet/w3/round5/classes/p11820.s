# n=5 model=out iset=I1 prefix14_class=11820
mov S2, P2
cmp P3, P0
cmovle S1, P3
cmovle P3, P0
cmovl P0, S1
cmp S2, P1
cmovl S2, P1
cmovle P1, P2
cmp S2, P3
mov S0, S2
cmovl S0, P3
cmovge S2, P3
cmp P1, P0
cmovl S0, P0
