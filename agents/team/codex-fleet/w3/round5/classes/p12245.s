# n=5 model=out iset=I1 prefix14_class=12245
mov S2, P3
mov S0, P2
cmp S0, P0
cmovge S0, P0
cmovl P2, P0
cmp P1, S2
cmovge S2, P1
cmovle P3, P1
cmp P3, S0
cmovle S1, P3
cmovle P3, S0
mov P0, P3
cmovl S0, S1
cmp S2, P2
