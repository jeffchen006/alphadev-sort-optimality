# n=5 model=out iset=I1 prefix14_class=3017
mov S0, P0
cmp P3, P2
cmovl S1, P3
cmovle P3, P2
cmovl P2, S1
cmp S0, P1
cmovg P0, P1
cmovge P1, S0
cmp P3, P1
cmovl S0, P3
cmovge S0, P1
cmovg P1, P3
cmp P0, P2
mov P3, P2
