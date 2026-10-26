# n=5 model=out iset=I1 prefix14_class=6641
cmp P1, P2
cmovl S2, P1
cmovge S2, P2
cmovle P1, P2
mov S0, P1
cmp P3, P0
mov P2, P3
cmovle P3, P0
cmovg P2, P0
cmp P3, P1
cmovg P1, P3
cmovle S0, P3
cmovl P0, S2
cmp S2, P2
