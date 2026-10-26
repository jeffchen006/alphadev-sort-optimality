# n=5 model=out iset=I1 prefix14_class=7283
cmp P1, P3
mov S0, P3
cmovl P3, P1
cmovge S0, P1
mov S1, P0
cmp P2, S1
cmovl P0, P2
cmovle P2, S1
cmp P0, P3
cmovge S2, P0
cmovge P0, P3
cmovge P3, S2
cmp S0, P2
cmovge S2, P2
