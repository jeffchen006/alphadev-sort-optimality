# n=5 model=out iset=I1 prefix14_class=4379
mov S2, P2
cmp P0, S2
cmovl S2, P0
cmovl P0, P2
cmp P1, P3
cmovl S0, P3
cmovge S0, P1
mov S1, S2
cmovl P3, P1
cmp S2, P3
cmovle S1, P3
cmovg S2, P3
mov S2, S1
cmp P0, S0
