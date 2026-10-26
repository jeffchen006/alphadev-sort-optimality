# n=5 model=out iset=I1 prefix14_class=7140
cmp P2, P0
cmovle S1, P2
mov S2, P1
cmovle P2, P0
cmovl P0, S1
cmp S2, P3
cmovl P1, P3
cmovge S2, P3
mov S0, P0
cmp S2, P0
cmovle S0, S2
mov P3, P2
cmovl S2, P0
cmp P1, P2
