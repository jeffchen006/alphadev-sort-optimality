# n=5 model=out iset=I1 prefix14_class=7871
cmp P3, P2
mov S1, P1
cmovl S2, P2
cmovge S2, P3
cmovl P2, P3
cmp P1, P0
cmovle S1, P0
cmovg P1, P0
cmp P1, P2
cmovge S0, P1
cmovg P1, P2
mov P1, S1
cmovg P2, S0
cmp S2, P1
