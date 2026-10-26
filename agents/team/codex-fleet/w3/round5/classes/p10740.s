# n=5 model=out iset=I1 prefix14_class=10740
mov S0, P0
cmp P2, S0
cmovge S0, P2
cmovle P0, P2
cmp P3, P1
cmovle P2, P3
cmovle P3, P1
cmovl P1, P2
cmp S0, P3
cmovge S2, S0
cmovl S2, P3
cmovle P3, S0
mov S0, P1
cmp P0, S0
