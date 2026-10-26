# n=5 model=out iset=I1 prefix14_class=12010
cmp P1, P3
cmovge S0, P3
cmovg P3, P1
cmovl S0, P1
mov S1, P0
cmp S1, P2
cmovle S1, P2
cmovle P2, P0
cmp P2, S0
cmovle P0, S0
mov P1, S1
cmovl S0, P2
cmovle P2, P0
cmp P3, P1
