# n=5 model=out iset=I1 prefix14_class=4276
mov S1, P3
cmp P3, P0
cmovge P3, P0
cmovle S1, P0
mov S2, P2
cmp S2, P1
cmovge S2, P1
cmovge P1, P2
cmp S2, P3
cmovl P0, P3
cmovl P3, S2
cmovl S2, P0
cmp P1, S1
mov P3, S1
