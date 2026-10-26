# n=5 model=out iset=I1 prefix14_class=3866
cmp P1, P0
mov S2, P2
cmovge S1, P0
cmovl S1, P1
cmovge P0, P1
cmp S2, P3
cmovle S2, P3
cmovle P3, P2
mov S0, S1
cmp S0, P3
cmovle S0, P3
cmovle P3, S1
cmp S2, P0
cmovle P1, P0
