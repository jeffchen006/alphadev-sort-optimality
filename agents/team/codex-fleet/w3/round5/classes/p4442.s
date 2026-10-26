# n=5 model=out iset=I1 prefix14_class=4442
cmp P3, P0
cmovge S2, P0
cmovg P0, P3
cmovg P3, S2
cmp P1, P2
cmovge S0, P1
cmovl S0, P2
mov S1, S0
cmovl P2, P1
cmp S0, P0
cmovle S1, P0
cmovl P0, S0
mov S0, P2
cmp P2, P3
