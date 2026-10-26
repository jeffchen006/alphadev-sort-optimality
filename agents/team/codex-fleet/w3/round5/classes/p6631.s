# n=5 model=out iset=I1 prefix14_class=6631
cmp P1, P0
mov S2, P2
cmovge S1, P1
cmovl S1, P0
cmovge P1, P0
cmp S2, P3
cmovge P2, P3
cmovle S2, P3
mov S0, S2
cmp S1, S2
cmovge S2, S1
cmovge S1, S0
cmp P1, P2
cmovl P3, P1
