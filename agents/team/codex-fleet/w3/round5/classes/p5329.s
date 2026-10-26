# n=5 model=out iset=I1 prefix14_class=5329
cmp P0, P3
mov S1, P3
cmovge P3, P0
cmovl S1, P0
cmp P1, P2
mov S0, P1
cmovge S0, P2
cmovle P1, P2
cmp S1, S0
cmovl P0, S0
cmovge P0, S1
cmovl S0, S1
cmp P3, P1
cmovge S1, P3
