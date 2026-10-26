# n=5 model=out iset=I1 prefix14_class=295
cmp P3, P1
mov S2, P0
cmovge S1, P3
cmovge P3, P1
cmovge P1, S1
cmp P2, P0
cmovge S2, P2
cmovl P0, P2
cmp P3, P0
cmovle P2, P0
cmovle P0, P3
cmovle P3, P2
cmp S2, P1
mov S0, P1
