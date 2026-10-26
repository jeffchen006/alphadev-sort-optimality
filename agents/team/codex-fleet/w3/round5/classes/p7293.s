# n=5 model=out iset=I1 prefix14_class=7293
cmp P3, P1
mov S1, P1
mov S0, P2
cmovle P1, P3
cmovge S1, P3
cmp P0, P2
cmovle P2, P0
mov S2, P2
cmovl P0, S0
cmp S2, P1
cmovg S2, P1
cmovge P1, P2
cmp S1, P0
cmovg P2, S1
