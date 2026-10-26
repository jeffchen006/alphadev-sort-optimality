# n=5 model=out iset=I1 prefix14_class=361
mov S0, P1
cmp P2, P1
cmovg S0, P2
cmovge P2, P1
cmp P0, P3
cmovge S1, P0
cmovge P0, P3
mov S2, P2
cmovge P3, S1
cmp P0, P2
cmovle P2, P0
mov P1, P3
cmovl P0, S2
cmp S0, P1
