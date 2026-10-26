# n=5 model=out iset=I1 prefix14_class=151
mov S1, P1
cmp P1, P3
cmovg S1, P3
cmovl P1, P3
cmp P2, P0
mov S0, P0
cmovl P0, P2
cmovge S0, P2
mov P2, S0
cmp S1, P0
mov P3, P0
cmovg P3, S1
cmovg S1, P0
mov P0, P3
