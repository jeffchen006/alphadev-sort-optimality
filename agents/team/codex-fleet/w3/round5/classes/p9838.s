# n=5 model=out iset=I1 prefix14_class=9838
mov S1, P1
cmp P0, P2
cmovl S2, P2
cmovge S2, P0
cmovl P2, P0
cmp S1, P3
cmovle S1, P3
mov S0, S2
cmovge P1, P3
cmp S2, S1
cmovge S2, S1
cmovl S0, S1
cmp P1, P2
cmovge S1, S2
