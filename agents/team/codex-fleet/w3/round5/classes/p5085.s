# n=5 model=out iset=I1 prefix14_class=5085
mov S1, P1
cmp P1, P3
cmovl P1, P3
cmovg S1, P3
cmp P2, P0
cmovge S0, P0
mov P3, P1
cmovge P0, P2
cmovge P2, S0
cmp S1, P2
mov S2, P2
cmovl P2, S1
cmovge S2, S1
cmp P0, P3
