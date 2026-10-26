# n=5 model=out iset=I1 prefix14_class=10277
mov S1, P0
mov S2, P2
cmp S2, P3
cmovge S2, P3
cmovle P2, P3
cmp P0, P1
cmovge P0, P1
cmovge P1, S1
cmp P2, P1
cmovle P3, P1
cmovl P1, P2
cmovl P2, P3
mov S0, S2
mov P2, P1
