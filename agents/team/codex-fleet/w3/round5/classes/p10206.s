# n=5 model=out iset=I1 prefix14_class=10206
cmp P0, P3
cmovg S1, P0
mov S0, P2
cmovge P0, P3
cmovg P3, S1
mov S2, P3
cmp P1, P2
cmovle P2, P1
cmovge S0, P1
cmp S2, S0
cmovl P3, S0
cmovl S0, S2
cmp P2, P0
cmovl S1, P0
