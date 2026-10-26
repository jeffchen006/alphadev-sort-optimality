# n=5 model=out iset=I1 prefix14_class=5500
cmp P2, P3
cmovl S0, P2
cmovle P2, P3
mov S2, P0
cmovl P3, S0
cmp S2, P1
cmovge P0, P1
mov S0, P3
cmovl S2, P1
cmp S0, P0
cmovl S0, P0
cmovle P0, P3
cmp P2, S2
cmovle P3, P2
