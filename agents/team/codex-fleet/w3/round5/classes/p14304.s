# n=5 model=out iset=I1 prefix14_class=14304
mov S1, P0
cmp P2, P0
cmovge S1, P2
mov S2, P1
cmovl P0, P2
cmp S2, P3
cmovle P1, P3
cmovg S2, P3
cmp S2, P0
cmovge S0, S2
cmovg S2, P0
cmovge P0, S0
mov P2, P0
cmp S1, P1
