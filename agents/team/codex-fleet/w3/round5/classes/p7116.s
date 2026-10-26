# n=5 model=out iset=I1 prefix14_class=7116
cmp P3, P2
mov S2, P2
mov S0, P0
cmovle P2, P3
cmovle P3, S2
cmp S0, P1
cmovl P0, P1
cmovle P1, S0
cmp P1, P2
cmovge S1, P1
cmovl S1, P2
cmovg P1, P2
cmp P3, P0
cmovge P2, P0
