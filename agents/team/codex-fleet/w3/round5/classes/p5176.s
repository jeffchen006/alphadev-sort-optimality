# n=5 model=out iset=I1 prefix14_class=5176
mov S2, P0
cmp S2, P1
cmovl P0, P1
cmovl P1, S2
cmp P3, P2
mov S0, P2
cmovle P2, P3
cmovl P3, S0
cmp P2, P1
cmovge S0, P2
cmovge P2, P1
mov P2, P3
cmovge P1, S0
cmp P0, P3
