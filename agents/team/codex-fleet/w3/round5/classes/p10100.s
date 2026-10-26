# n=5 model=out iset=I1 prefix14_class=10100
cmp P1, P2
cmovge S1, P1
cmovl S1, P2
cmovle P2, P1
cmp P3, P0
mov S2, P3
cmovge P3, P0
cmovg P0, S2
cmp S1, P0
cmovl S0, S1
cmovle S1, P0
cmovl P0, S0
cmp P3, P2
mov P1, P2
