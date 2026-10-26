# n=5 model=out iset=I1 prefix14_class=3307
mov S2, P2
cmp P3, S2
cmovge S2, P3
cmovl P2, P3
cmp P0, P1
mov P3, P0
cmovge P0, P1
cmovle P3, P1
cmp P0, P2
mov S0, P0
cmovle P0, P2
cmovge S0, P2
cmp S2, P3
cmovge S1, P3
