# n=5 model=out iset=I1 prefix14_class=12774
mov S1, P1
cmp P3, S1
cmovl P1, P3
mov S0, P0
cmovg S1, P3
cmp P0, P2
cmovge S0, P2
cmovge P2, P0
cmp S0, P1
cmovge S2, S0
mov P0, S1
cmovge S0, P1
cmovg P1, S2
cmp P2, S1
