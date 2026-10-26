# n=5 model=out iset=I1 prefix14_class=11113
mov S2, P3
cmp P0, P3
cmovl S2, P0
cmovge P3, P0
cmp P1, P2
cmovl P0, P1
cmovle P1, P2
cmovl P2, P0
cmp P1, P3
cmovl S0, P3
cmovl P3, P1
cmovl P1, S0
cmp S2, P2
cmovge P0, S2
