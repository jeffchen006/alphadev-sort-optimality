# n=5 model=out iset=I1 prefix14_class=6909
mov S0, P0
cmp P3, S0
mov S2, P2
cmovl P0, P3
cmovle P3, S0
cmp S2, P1
cmovl P2, P1
cmovge S2, P1
cmp P2, P3
cmovle S0, P3
cmovl P3, P2
mov P1, S2
cmovl P2, S0
cmp P0, S2
