# n=5 model=out iset=I1 prefix14_class=14264
mov S2, P0
mov S1, P1
cmp P3, S1
cmovle P1, P3
cmovge S1, P3
cmp P2, S2
cmovge S2, P2
cmovl P0, P2
mov S0, S1
cmp S0, S2
cmovg S1, S2
cmovge S2, S0
cmp P1, P0
cmovle P3, P0
