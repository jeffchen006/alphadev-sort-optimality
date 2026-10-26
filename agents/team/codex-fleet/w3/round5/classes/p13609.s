# n=5 model=out iset=I1 prefix14_class=13609
cmp P1, P2
cmovle S1, P1
cmovl P1, P2
cmovl P2, S1
cmp P3, P0
cmovl S0, P3
mov S2, P2
cmovge S0, P0
cmovl P3, P0
cmp S0, S2
cmovle P2, S0
cmovge S2, S0
mov P2, P3
cmovle S0, S2
