# n=5 model=out iset=I1 prefix14_class=4986
cmp P3, P2
cmovle S2, P3
cmovl P3, P2
mov S0, P3
cmovl P2, S2
cmp P1, P0
cmovge S1, P0
cmovge P0, P1
cmovge P1, S1
cmp P2, P1
cmovle S2, P1
cmovl P1, P2
cmovle P2, S2
cmp S0, P0
