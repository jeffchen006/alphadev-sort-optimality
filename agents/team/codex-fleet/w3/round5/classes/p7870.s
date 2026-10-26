# n=5 model=out iset=I1 prefix14_class=7870
cmp P2, P3
mov S1, P1
cmovl S2, P3
cmovge S2, P2
cmovl P3, P2
cmp P1, P0
cmovle S1, P0
cmovg P1, P0
cmp P1, P3
cmovge S0, P1
cmovg P1, P3
mov P1, S1
cmovg P3, S0
cmp S2, P1
