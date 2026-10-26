# n=5 model=out iset=I1 prefix14_class=11293
mov S1, P0
mov S2, P1
cmp P3, P0
cmovle P0, P3
cmovge S1, P3
cmp P1, P2
cmovle P1, P2
cmovl P2, S2
cmp S1, P1
cmovge P3, S1
cmovge S1, P1
cmovge P1, P3
mov P1, P2
mov S0, S1
