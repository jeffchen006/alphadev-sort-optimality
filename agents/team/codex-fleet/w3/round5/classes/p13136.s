# n=5 model=out iset=I1 prefix14_class=13136
mov S1, P2
cmp P2, P0
cmovle S1, P0
cmovge P2, P0
cmp P1, P3
cmovl S2, P1
cmovl P1, P3
mov S0, P2
cmovl P3, S2
cmp S0, P3
cmovge S0, P3
cmovg P3, P2
cmp P1, S1
cmovl S2, S1
