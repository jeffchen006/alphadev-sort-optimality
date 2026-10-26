# n=5 model=out iset=I1 prefix14_class=7649
mov S2, P0
cmp P1, S2
cmovl P0, P1
cmovge S2, P1
cmp P2, P3
cmovge P1, P3
cmovle P1, P2
cmovge P3, P2
cmp P0, P1
mov S0, P3
cmovle P2, P0
cmovle P0, P1
cmovl P1, P2
cmp S2, P3
