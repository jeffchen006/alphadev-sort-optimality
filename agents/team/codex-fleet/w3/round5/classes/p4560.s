# n=5 model=out iset=I1 prefix14_class=4560
cmp P2, P0
cmovle S0, P2
cmovg S0, P0
cmovge P0, P2
cmp P3, P1
mov S1, P3
cmovge P3, P1
cmovle S1, P1
cmp S1, P0
cmovge S2, S1
cmovl S2, P0
cmovl P0, S1
cmp S0, P3
cmovge S1, S0
