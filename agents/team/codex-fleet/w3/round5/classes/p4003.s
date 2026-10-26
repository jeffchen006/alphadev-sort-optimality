# n=5 model=out iset=I1 prefix14_class=4003
cmp P1, P0
mov S1, P1
cmovg S1, P0
mov S0, P3
cmovl P1, P0
mov P0, S1
cmp P3, P2
cmovge S0, P2
cmovg P2, P3
cmp S1, S0
cmovg S1, S0
cmovge S0, P0
cmp P2, P1
mov S1, P2
