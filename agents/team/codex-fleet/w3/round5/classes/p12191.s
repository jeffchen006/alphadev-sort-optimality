# n=5 model=out iset=I1 prefix14_class=12191
mov S1, P2
mov S0, P1
cmp P2, P0
cmovle P2, P0
cmovge S1, P0
cmp S0, P3
cmovl S0, P3
cmovg P1, P3
cmp P1, S1
cmovle P3, S1
cmovle S1, P1
cmovg P3, P1
cmp P2, S0
cmovle S1, P2
