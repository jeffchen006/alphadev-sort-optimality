# n=5 model=out iset=I1 prefix14_class=864
cmp P0, P3
cmovge S2, P3
cmovl S2, P0
cmovle P0, P3
cmp P2, P1
mov P3, P2
cmovg P2, P1
cmovg P1, P3
cmovg P3, P2
mov S0, P0
cmp P1, S0
cmovl P0, P1
cmovge S0, P1
cmp S2, P2
