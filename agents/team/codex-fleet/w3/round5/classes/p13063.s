# n=5 model=out iset=I1 prefix14_class=13063
mov S2, P2
cmp P1, S2
cmovle S2, P1
cmovge P2, P1
cmp P3, P0
cmovl S0, P3
cmovle P3, P0
cmovl P0, S0
mov S1, P2
cmp S2, P0
cmovl P1, S2
cmovl S2, P0
cmovl P0, P1
cmp P3, P2
