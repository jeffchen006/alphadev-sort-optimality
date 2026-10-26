# n=5 model=out iset=I1 prefix14_class=3021
mov S0, P3
cmp P0, P2
cmovl S1, P0
cmovl P0, P2
cmovl P2, S1
cmp S0, P1
cmovg P3, P1
cmovg P1, S0
cmp P0, P1
cmovle S2, P0
cmovge S2, P1
cmovge P1, P0
cmp P3, P2
cmovge S1, P2
