# n=5 model=out iset=I1 prefix14_class=12201
cmp P0, P2
mov S2, P2
cmovg S2, P0
cmovl P2, P0
cmp P3, P1
cmovle P0, P1
cmovl P1, P3
cmovl P3, P0
mov S0, P2
cmp S0, P1
cmovge S0, P1
cmovge P1, P2
cmp P3, S2
cmovl S1, S2
