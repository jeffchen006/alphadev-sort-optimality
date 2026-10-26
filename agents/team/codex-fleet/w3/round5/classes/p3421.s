# n=5 model=out iset=I1 prefix14_class=3421
mov S1, P3
cmp S1, P1
cmovle P3, P1
cmovl P1, S1
cmp P0, P2
cmovge S0, P0
cmovg P0, P2
cmovl S0, P2
cmp P0, P1
cmovge P2, P0
cmovl P2, P1
cmovle P1, P0
cmp S0, P3
cmovle P0, P3
