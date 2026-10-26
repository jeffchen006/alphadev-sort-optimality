# n=5 model=out iset=I1 prefix14_class=13456
cmp P3, P2
cmovle S0, P2
cmovl P2, P3
cmovge S0, P3
cmp P1, P0
cmovle S2, P1
cmovl P1, P0
cmovl P0, S2
mov S1, P0
cmp S1, P2
cmovl S1, P2
cmovle P2, P0
cmp P1, S0
cmovg S2, S0
