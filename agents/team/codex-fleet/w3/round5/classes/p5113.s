# n=5 model=out iset=I1 prefix14_class=5113
cmp P1, P0
mov S0, P2
cmovle S1, P1
cmovle P1, P0
cmovge S1, P0
cmp P2, P3
cmovge S0, P3
cmovl P2, P3
mov P0, S1
cmp S0, P0
cmovge P0, S0
cmovl S1, S0
mov S1, P0
mov S2, P2
