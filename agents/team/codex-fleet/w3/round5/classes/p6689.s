# n=5 model=out iset=I1 prefix14_class=6689
cmp P2, P1
mov S1, P0
cmovle S2, P1
cmovl P1, P2
cmovle P2, S2
cmp P3, S1
cmovl S1, P3
cmovl P3, P0
cmp P3, P2
mov S0, P3
cmovl S0, P2
cmovle P2, P3
cmp S1, P1
cmovge S0, P1
