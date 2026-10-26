# n=5 model=out iset=I1 prefix14_class=10161
cmp P0, P3
cmovge S1, P0
cmovg P0, P3
cmovg P3, S1
cmp P1, P2
mov S0, P2
cmovle S0, P1
cmovl P1, P2
mov S2, P1
cmp P3, S2
cmovl S2, P3
cmovg P1, P3
cmp P0, S0
cmovge S1, P0
