# n=5 model=out iset=I1 prefix14_class=1296
mov S1, P3
cmp P2, P3
mov S0, P1
cmovge P3, P2
cmovg P2, S1
cmp S0, P0
cmovl P1, P0
cmovle P0, S0
mov S2, P1
cmp S2, P3
cmovge S2, P3
cmovle P1, P3
cmp P2, P0
cmovge S0, P2
