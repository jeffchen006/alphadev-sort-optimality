# n=5 model=out iset=I1 prefix14_class=12009
cmp P1, P3
cmovge S0, P3
cmovg P3, P1
cmovl S0, P1
mov S1, P2
cmp S1, P0
cmovle S1, P0
cmovle P0, P2
cmp P0, S0
cmovle P2, S0
mov P1, S1
cmovl S0, P0
cmovle P0, P2
cmp P3, P1
