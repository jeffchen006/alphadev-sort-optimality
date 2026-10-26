# n=5 model=out iset=I1 prefix14_class=12484
cmp P3, P1
cmovl S2, P1
cmovge S2, P3
cmovle P1, P3
cmp P2, P0
cmovge S1, P0
cmovg P0, P2
cmovge P2, S1
cmp P1, P2
cmovl S0, P1
cmovl P1, P2
cmovge S0, P2
mov S0, P1
cmp S2, P0
