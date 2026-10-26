# n=5 model=out iset=I1 prefix14_class=13188
mov S2, P0
cmp P2, S2
cmovle P0, P2
cmovge S2, P2
cmp P1, P3
cmovle S0, P1
mov P2, P0
cmovl P1, P3
cmovle P3, S0
cmp P0, P3
cmovg P2, P3
cmovl P0, P3
cmp S2, P1
cmovl P2, P1
