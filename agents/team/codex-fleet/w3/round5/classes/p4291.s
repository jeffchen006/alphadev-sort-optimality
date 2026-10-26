# n=5 model=out iset=I1 prefix14_class=4291
mov S0, P2
cmp S0, P0
cmovge S0, P0
cmovl P2, P0
cmp P1, P3
mov S2, P1
cmovge S2, P3
cmovle P1, P3
mov P3, S0
cmp S0, S2
cmovle P3, S2
cmovle S2, S0
cmp P1, P2
cmovl S2, P2
