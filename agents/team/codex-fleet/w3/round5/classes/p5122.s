# n=5 model=out iset=I1 prefix14_class=5122
cmp P3, P1
mov S2, P1
cmovge S2, P3
cmovl P1, P3
cmp P2, P0
mov S1, P2
cmovl P2, P0
mov S0, P1
cmovg S1, P0
cmp S1, P1
cmovge S0, S1
cmovle P1, S1
cmp P2, S2
cmovge P3, S2
