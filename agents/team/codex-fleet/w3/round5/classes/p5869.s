# n=5 model=out iset=I1 prefix14_class=5869
cmp P2, P0
mov S0, P3
cmovl S1, P0
cmovge S1, P2
cmovge P2, P0
cmp P1, P3
mov S2, S1
cmovle S0, P1
cmovl P1, P3
cmp P1, S1
cmovg S1, P1
cmovl S2, P1
cmp S0, P2
cmovl S1, S0
