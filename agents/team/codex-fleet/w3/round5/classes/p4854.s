# n=5 model=out iset=I1 prefix14_class=4854
mov S0, P0
cmp P0, P3
cmovge P0, P3
cmovl S0, P3
mov S1, P0
cmp P1, P2
mov S2, P2
cmovge S2, P1
cmovle P2, P1
cmp S1, P2
cmovl S1, P2
cmovle P2, P0
cmp S2, S0
cmovl P0, S2
