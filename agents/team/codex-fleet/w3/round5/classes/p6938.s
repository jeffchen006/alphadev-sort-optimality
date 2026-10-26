# n=5 model=out iset=I1 prefix14_class=6938
cmp P0, P1
cmovge S1, P0
cmovge P0, P1
cmovl S1, P1
mov P1, P3
cmp P2, P3
cmovl P3, P2
cmovg P1, P2
cmp S1, P1
cmovle S0, P1
cmovl P1, S1
cmovl S1, S0
cmp P3, P0
cmovl S2, P0
