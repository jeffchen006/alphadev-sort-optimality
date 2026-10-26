# n=5 model=out iset=I1 prefix14_class=14149
cmp P0, P2
mov S2, P1
cmovl S1, P2
cmovl P2, P0
cmovl P0, S1
cmp P3, P1
cmovge S2, P3
cmovge P3, P1
mov P1, S2
cmp S2, P0
cmovg P1, P0
cmovge P0, S2
cmp P3, P2
cmovle S0, P3
