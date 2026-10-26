# n=5 model=out iset=I1 prefix14_class=9159
mov S0, P3
cmp P0, P3
cmovle P3, P0
cmovge S0, P0
cmp P1, P2
cmovl P0, P2
cmovl P2, P1
mov S1, P3
cmovl P1, P0
cmp S1, P2
cmovge P3, P2
cmovge P2, S1
cmp S0, P1
mov S2, P1
