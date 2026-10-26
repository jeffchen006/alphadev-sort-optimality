# n=5 model=out iset=I1 prefix14_class=12035
mov S1, P1
cmp P1, P2
cmovl P1, P2
cmovge S1, P2
cmovge P2, P1
cmp P3, P0
cmovle S0, P0
cmovl P0, P3
cmovle P3, S0
cmp S1, P0
cmovle S2, P0
cmovl P0, S1
cmovl S1, S2
cmp P3, P1
