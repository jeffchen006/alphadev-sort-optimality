# n=5 model=out iset=I1 prefix14_class=12672
cmp P0, P3
mov S0, P3
cmovl S0, P0
cmovg P3, P0
cmovg P0, S0
cmp P1, P2
cmovl S2, P2
cmovle P2, P1
cmovl P1, S2
cmp S0, P2
cmovle P0, P2
cmovge S0, P2
cmp P3, P1
mov P2, P3
