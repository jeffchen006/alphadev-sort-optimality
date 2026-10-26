# n=5 model=out iset=I1 prefix14_class=6278
cmp P1, P0
mov S1, P2
cmovl S0, P0
cmovl P0, P1
cmovl P1, S0
mov S2, P1
cmp S1, P3
cmovge P2, P3
cmovg P3, S1
cmovg S1, P2
cmp S2, P3
cmovge S2, P3
cmovle P1, P3
cmp P2, P0
