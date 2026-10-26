# n=5 model=out iset=I1 prefix14_class=7595
cmp P2, P0
mov S0, P0
cmovg S0, P2
cmovl P0, P2
cmp P1, P3
cmovge S2, P3
mov S1, P0
cmovl S2, P1
cmovl P1, P3
cmp P0, S2
cmovle S1, S2
cmovg P0, S2
cmp S0, P1
cmovl P2, P1
