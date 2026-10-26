# n=5 model=out iset=I1 prefix14_class=13014
cmp P3, P2
mov S1, P0
cmovge S0, P2
cmovle S0, P3
cmovge P2, P3
cmp P0, P1
cmovge P0, P1
cmovle S1, P1
cmp S0, P0
cmovl S2, S0
cmovle S0, P0
cmovl P0, S2
cmp P2, S1
cmovle P1, S1
