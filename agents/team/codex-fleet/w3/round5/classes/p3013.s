# n=5 model=out iset=I1 prefix14_class=3013
cmp P1, P2
cmovl S1, P1
cmovle P1, P2
cmovl P2, S1
mov S0, P0
cmp P0, P3
mov S2, P1
cmovge P0, P3
cmovg P3, S0
cmp S2, P3
cmovg S2, P3
cmovg P3, P1
cmp P0, P2
cmovl S0, P0
