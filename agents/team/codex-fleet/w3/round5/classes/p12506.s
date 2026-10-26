# n=5 model=out iset=I1 prefix14_class=12506
mov S0, P0
cmp P0, P1
cmovle P0, P1
cmovle P1, S0
mov S1, P3
cmp P2, P3
cmovl S1, P2
cmovge P3, P2
cmp S1, P1
cmovl S0, S1
cmovl S1, P1
cmovl P1, S0
mov P2, P0
cmp P2, P3
