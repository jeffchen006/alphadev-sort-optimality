# n=5 model=out iset=I1 prefix14_class=4219
mov S2, P2
cmp P1, S2
mov S1, P3
cmovge P2, P1
cmovle S2, P1
cmp S1, P0
cmovl P3, P0
cmovl P0, S1
cmp S2, P0
cmovge S0, P0
cmovl S0, S2
cmovge P0, S2
cmp P2, P3
cmovge S1, P2
