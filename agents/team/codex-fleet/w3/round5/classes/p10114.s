# n=5 model=out iset=I1 prefix14_class=10114
cmp P2, P0
cmovge S0, P0
cmovge P0, P2
cmovl S0, P2
cmp P1, P3
mov S2, P1
cmovge P1, P3
cmovg P3, S2
cmp P0, P3
cmovl S1, P0
cmovle P0, P3
cmovl P3, S1
cmp S0, P1
cmovg S2, P1
