# n=5 model=out iset=I1 prefix14_class=7852
cmp P3, P0
cmovge S1, P3
cmovl S1, P0
cmovl P0, P3
mov S0, P2
cmp P1, P2
cmovle S0, P1
mov S2, P0
cmovl P1, P2
cmp S0, P0
cmovg S2, S0
cmovle P0, S0
cmp S1, P1
cmovge S0, S1
