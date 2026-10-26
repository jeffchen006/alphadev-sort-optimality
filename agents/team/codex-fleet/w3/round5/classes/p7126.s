# n=5 model=out iset=I1 prefix14_class=7126
mov S0, P0
cmp P1, S0
cmovle S0, P1
mov S2, P3
cmovl P1, P0
cmp S2, P2
cmovle P3, P2
cmovge S2, P2
cmp S0, S2
cmovl S1, S2
cmovle S2, S0
cmovge S1, S0
cmp P1, P3
cmovge P2, P1
