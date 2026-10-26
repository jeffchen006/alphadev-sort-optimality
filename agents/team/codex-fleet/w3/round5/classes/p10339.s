# n=5 model=out iset=I1 prefix14_class=10339
cmp P3, P1
cmovg S0, P3
cmovle S0, P1
cmovle P1, P3
mov P3, P0
cmp P3, P2
cmovge P3, P2
mov S1, P1
cmovl P0, P2
cmp S0, P0
cmovge S2, P0
cmovge P0, S0
cmovge S0, S2
cmp S1, P3
