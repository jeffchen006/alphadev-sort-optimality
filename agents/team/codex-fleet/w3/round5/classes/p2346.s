# n=5 model=out iset=I1 prefix14_class=2346
cmp P1, P3
cmovl S1, P1
cmovl P1, P3
cmovl P3, S1
mov S2, P0
cmp S2, P2
cmovle S2, P2
cmovge P0, P2
cmp P1, S2
cmovg P2, S2
cmovge S2, P1
cmovle P2, P1
cmp P0, P3
cmovl S0, P3
