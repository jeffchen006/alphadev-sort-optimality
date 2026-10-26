# n=5 model=out iset=I1 prefix14_class=2894
mov S2, P2
cmp S2, P0
cmovle P2, P0
mov S1, P3
cmovl P0, S2
cmp P3, P1
cmovge S1, P1
cmovl P3, P1
mov S2, P2
cmp P3, P2
cmovl S2, P3
cmovl P3, P2
cmp S1, P0
cmovle S0, S1
