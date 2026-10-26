# n=5 model=out iset=I1 prefix14_class=5117
mov S0, P2
cmp S0, P3
mov S1, P0
cmovle P2, P3
cmovle P3, S0
cmp S1, P1
cmovl S1, P1
cmovg P0, P1
cmp P0, P3
cmovl S2, P3
cmovle P3, P0
cmovge S2, P0
mov P3, S2
mov P1, P2
