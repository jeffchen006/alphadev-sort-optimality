# n=5 model=out iset=I1 prefix14_class=13290
cmp P2, P0
mov S2, P3
cmovle S1, P0
cmovle P0, P2
cmovle P2, S1
cmp P1, S2
cmovl S2, P1
cmovl P1, P3
mov S0, S2
cmp S0, P0
cmovge S2, P0
cmovl S0, P0
cmovge P0, S0
mov S2, P2
