# n=5 model=out iset=I1 prefix14_class=4908
cmp P1, P0
mov S2, P3
cmovge S0, P1
cmovl S0, P0
cmovle P0, P1
cmp P2, S2
cmovle P3, P2
mov P1, P0
cmovl P2, S2
cmp P0, P3
cmovg P1, P3
cmovle P0, P3
cmp S0, P2
cmovg P3, S0
