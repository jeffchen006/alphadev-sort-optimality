# n=5 model=out iset=I1 prefix14_class=5207
mov S2, P1
cmp S2, P3
cmovge S2, P3
mov S1, P0
cmovle P1, P3
cmp P2, P0
cmovl P0, P2
cmovl P2, S1
cmp S2, P0
cmovge S0, S2
cmovge S2, P0
mov P3, P2
cmovge P0, S0
cmp P1, P2
