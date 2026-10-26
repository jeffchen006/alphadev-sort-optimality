# n=5 model=out iset=I1 prefix14_class=5471
mov S0, P1
cmp P1, P3
cmovl P1, P3
cmovle P3, S0
cmp P2, P0
cmovge S2, P2
cmovl S2, P0
cmovg P2, P0
mov P0, P2
cmp P0, P3
cmovle P2, P3
cmovge P0, P3
cmp S2, P1
cmovle P3, S2
