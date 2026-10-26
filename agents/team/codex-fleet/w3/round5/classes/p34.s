# n=5 model=out iset=I1 prefix14_class=34
mov S2, P0
cmp P3, P0
cmovle P0, P3
cmovle P3, S2
cmovl S2, P0
cmp P1, P2
cmovl S0, P1
cmovge S0, P2
cmovg P2, P1
cmp S2, S0
cmovg P0, S0
cmovl S2, S0
cmp P3, P2
mov S0, P3
