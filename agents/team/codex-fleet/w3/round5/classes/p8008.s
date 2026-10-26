# n=5 model=out iset=I1 prefix14_class=8008
mov S1, P0
cmp P1, S1
cmovge S1, P1
cmovg P1, P0
mov S2, P1
cmp P2, P3
cmovle P0, P3
cmovl P3, P2
mov S0, S1
cmovle P2, P0
cmp P3, P1
cmovl S2, P3
cmovge P1, P3
cmp S1, P2
