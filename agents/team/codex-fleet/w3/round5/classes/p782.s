# n=5 model=out iset=I1 prefix14_class=782
cmp P0, P3
mov S0, P2
mov S2, P0
cmovle S2, P3
cmovl P3, P0
cmovl P0, S2
cmp S0, P1
cmovge S0, P1
cmovl P2, P1
cmp P2, S2
mov S1, P3
cmovg P0, P2
cmovl S2, P2
cmp P3, S0
