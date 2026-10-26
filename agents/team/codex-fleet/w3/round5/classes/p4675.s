# n=5 model=out iset=I1 prefix14_class=4675
cmp P3, P0
cmovge S0, P0
mov S1, P1
cmovg P0, P3
cmovg P3, S0
cmp P2, P1
cmovle S1, P2
cmovl P2, P1
cmp P2, P0
cmovge S2, P2
cmovg P2, P0
cmovl S2, P0
mov S2, S1
cmp S1, P3
