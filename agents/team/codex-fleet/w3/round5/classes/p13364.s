# n=5 model=out iset=I1 prefix14_class=13364
cmp P1, P3
cmovl S0, P1
cmovl P1, P3
cmovl P3, S0
mov S1, P2
cmp P0, P2
cmovg P2, P0
cmovl S1, P0
cmp S1, P3
cmovge S2, P3
cmovle S2, S1
cmovg P3, S1
cmp P2, P1
cmovge P0, P1
