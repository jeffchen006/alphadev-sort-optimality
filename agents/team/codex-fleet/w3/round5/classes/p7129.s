# n=5 model=out iset=I1 prefix14_class=7129
mov S2, P0
cmp P2, P1
mov S0, P1
cmovl P1, P2
cmovle P2, S0
cmp P0, P3
cmovl S2, P3
cmovg P0, P3
cmp P1, P0
cmovle P3, P0
cmovge P3, P1
cmovl P0, P1
cmp S2, P2
cmovl P1, P2
