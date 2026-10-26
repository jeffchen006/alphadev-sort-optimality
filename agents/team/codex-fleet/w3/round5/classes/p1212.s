# n=5 model=out iset=I1 prefix14_class=1212
mov S0, P0
cmp P0, P1
cmovl P0, P1
mov S2, P2
cmovle P1, S0
cmp P2, P3
mov S0, P0
cmovl S2, P3
cmovg P2, P3
cmp S0, S2
cmovge S0, S2
cmovge S2, P0
cmp P1, P2
mov P0, P1
