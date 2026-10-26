# n=5 model=out iset=I1 prefix14_class=6174
mov S0, P3
mov S2, P2
cmp P3, P0
cmovl S0, P0
cmovg P3, P0
cmp S2, P1
cmovle P2, P1
cmovle P1, S2
mov S1, S0
cmp P2, S1
cmovge S0, P2
cmovg P2, S1
mov S0, P1
cmp P3, P1
