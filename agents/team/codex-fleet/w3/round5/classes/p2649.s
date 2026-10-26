# n=5 model=out iset=I1 prefix14_class=2649
mov S1, P1
cmp P1, P3
cmovl S1, P3
cmovge P1, P3
mov S2, P2
cmp P0, S2
cmovl P2, P0
cmovge S2, P0
cmp S2, S1
mov P3, S2
cmovle S2, S1
cmovge P3, S1
mov S0, P3
cmp P1, P2
