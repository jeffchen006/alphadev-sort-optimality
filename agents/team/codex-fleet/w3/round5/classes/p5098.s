# n=5 model=out iset=I1 prefix14_class=5098
mov S0, P0
cmp S0, P3
cmovle S0, P3
cmovge P0, P3
cmp P1, P2
cmovle S2, P2
cmovge S2, P1
cmovge P1, P2
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
cmovl P1, S1
mov P3, P0
cmp S2, S0
