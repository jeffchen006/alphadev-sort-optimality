# n=5 model=out iset=I1 prefix14_class=6214
mov S0, P2
mov S1, P0
cmp S1, P1
cmovl S1, P1
cmovg P0, P1
cmp P3, P2
cmovge S0, P3
mov P1, S1
cmovle P2, P3
cmp S1, S0
cmovle S1, S0
cmovle S0, P1
mov S1, S0
cmp P0, P2
