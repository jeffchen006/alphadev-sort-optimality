# n=5 model=out iset=I1 prefix14_class=13200
cmp P1, P0
mov S1, P0
cmovl P0, P1
cmovg S1, P1
cmp P3, P2
cmovle S2, P2
cmovl P2, P3
cmovl P3, S2
cmp P2, P0
cmovge S0, P0
cmovl S0, P2
cmovle P2, P0
mov S0, P3
cmp S0, S1
