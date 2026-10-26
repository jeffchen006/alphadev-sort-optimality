# n=5 model=out iset=I1 prefix14_class=3882
cmp P2, P3
cmovge S2, P2
cmovge P2, P3
cmovge P3, S2
mov S2, P0
cmp S2, P1
cmovle P0, P1
cmovl P1, S2
mov S0, P2
cmp P2, P1
cmovl P2, P1
cmovl P1, S0
cmp P0, P3
cmovge P1, P0
