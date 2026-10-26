# n=5 model=out iset=I1 prefix14_class=1611
mov S2, P0
cmp P0, P2
cmovl S2, P2
cmovg P0, P2
mov S0, P1
cmp P3, S0
cmovge S0, P3
cmovg P3, P1
cmovle P1, P3
cmp P0, P3
cmovl P1, P0
cmovle P0, P3
cmp S0, S2
mov P3, S2
