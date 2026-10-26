# n=5 model=out iset=I1 prefix14_class=4131
mov S0, P1
cmp P2, S0
cmovl P1, P2
mov S1, P3
cmovg S0, P2
mov S2, P1
cmp P0, S1
cmovl S1, P0
cmovge P3, P0
mov P0, S0
cmp S1, P1
cmovge P1, S1
cmovge S1, S2
mov S1, P1
