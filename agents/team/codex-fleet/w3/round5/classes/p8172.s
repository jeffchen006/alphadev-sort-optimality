# n=5 model=out iset=I1 prefix14_class=8172
cmp P0, P3
cmovle S2, P0
cmovl P0, P3
mov S1, P2
cmovl P3, S2
cmp P1, P2
cmovg P2, P1
cmovl S1, P1
mov S2, P2
cmp P3, S1
cmovge S0, P3
cmovge P3, S1
cmovge S1, S0
cmp S2, P0
