# n=5 model=out iset=I1 prefix14_class=7047
cmp P3, P0
cmovge S0, P0
cmovge P0, P3
mov S2, P2
cmovg P3, S0
cmp S2, P1
cmovg S2, P1
cmovl P2, P1
mov S1, S2
cmp S2, P3
cmovl S1, P3
cmovle P3, S2
cmp P2, P0
cmovl S2, S1
