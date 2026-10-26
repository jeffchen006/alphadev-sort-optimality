# n=5 model=out iset=I1 prefix14_class=10731
mov S1, P1
cmp P2, S1
cmovg S1, P2
cmovge P2, P1
cmp P0, P3
cmovge P1, P0
mov S0, P2
cmovl P1, P3
cmovl P3, P0
cmp S1, P1
cmovge S2, P1
cmovge P1, S1
cmovge S1, S2
mov P1, S1
