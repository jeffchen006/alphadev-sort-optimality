# n=5 model=out iset=I1 prefix14_class=3011
cmp P1, P2
cmovl S1, P1
cmovle P1, P2
cmovl P2, S1
mov S0, P3
cmp P3, P0
mov S2, P1
cmovge P3, P0
cmovg P0, S0
cmp S2, P0
cmovge P1, P0
cmovg P0, S2
cmp P3, P2
mov S2, P3
