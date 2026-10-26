# n=5 model=out iset=I1 prefix14_class=14021
mov S1, P2
cmp P2, P3
cmovg S1, P3
cmovge P3, P2
mov S2, S1
mov S0, P3
cmp P0, P1
cmovle P2, P0
cmovl P0, P1
cmovl P1, P2
cmp P3, P0
cmovle P3, P0
cmovge S0, P0
cmp S2, P1
