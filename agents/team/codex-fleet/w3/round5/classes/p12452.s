# n=5 model=out iset=I1 prefix14_class=12452
cmp P1, P0
cmovl S0, P1
mov S1, P3
cmovl P1, P0
cmovl P0, S0
cmp P3, P2
cmovge P3, P2
cmovl S1, P2
cmp P3, P0
cmovle S2, P0
cmovge S2, P3
cmovl P0, P3
cmp S1, P1
cmovg S0, S1
