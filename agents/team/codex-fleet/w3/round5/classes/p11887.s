# n=5 model=out iset=I1 prefix14_class=11887
cmp P1, P2
cmovle S2, P1
cmovl P1, P2
mov S0, P3
cmovle P2, S2
cmp S0, P0
cmovl S0, P0
cmovg P3, P0
cmp S0, P1
mov S1, P1
cmovge S1, S0
mov S1, P2
cmovl P1, S0
cmp P2, P3
