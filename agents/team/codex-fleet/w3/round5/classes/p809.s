# n=5 model=out iset=I1 prefix14_class=809
mov S1, P0
cmp S1, P2
cmovge S1, P2
mov S2, P3
cmovg P2, P0
mov P0, P2
cmp S2, P1
cmovg S2, P1
cmovg P1, P3
cmp P1, P0
cmovl P2, P1
mov S0, P2
cmovg P0, P1
cmp S2, S1
