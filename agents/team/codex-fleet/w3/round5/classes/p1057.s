# n=5 model=out iset=I1 prefix14_class=1057
mov S0, P3
mov S1, P0
cmp S1, P2
cmovl S1, P2
cmovl P2, P0
cmp S0, P1
cmovge S0, P1
cmovg P1, P3
mov S2, P1
cmp P1, S1
cmovge P1, S1
cmovge S1, S2
mov S2, P2
mov P0, P1
