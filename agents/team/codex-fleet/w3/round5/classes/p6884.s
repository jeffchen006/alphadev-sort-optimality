# n=5 model=out iset=I1 prefix14_class=6884
mov S0, P1
cmp P3, P0
mov S2, P0
cmovle S2, P3
cmovl P3, P0
cmp P1, P2
cmovge P1, P2
cmovl S0, P2
cmp S0, P3
cmovge S1, P3
cmovl S1, S0
cmovge P3, S0
mov P3, S1
cmp S2, P1
