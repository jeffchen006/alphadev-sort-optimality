# n=5 model=out iset=I1 prefix14_class=4105
mov S1, P1
cmp P3, P1
cmovge S1, P3
mov S2, P2
cmovl P1, P3
cmp P0, P2
cmovg S2, P0
cmovg P0, P2
cmp P1, P0
cmovge S0, P0
mov P3, S1
cmovge P0, P1
cmovge P1, S0
cmp S2, P3
