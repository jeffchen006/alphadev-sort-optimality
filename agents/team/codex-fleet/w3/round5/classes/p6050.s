# n=5 model=out iset=I1 prefix14_class=6050
cmp P0, P3
mov S0, P0
cmovl S0, P3
cmovl P3, P0
cmp P2, P1
cmovle P0, P1
cmovle P1, P2
mov S2, S0
cmovle P2, P0
cmp P2, S2
cmovge S2, P2
mov S2, P3
cmovl S0, P2
cmp S2, P1
