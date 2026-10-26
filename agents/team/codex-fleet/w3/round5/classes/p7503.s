# n=5 model=out iset=I1 prefix14_class=7503
mov S1, P0
cmp P0, P3
cmovg S1, P3
mov S2, P2
cmovge P3, P0
cmp P2, P1
cmovge S2, P1
cmovl P2, P1
cmp S1, S2
cmovle S0, S2
cmovl S2, S1
cmovge S0, S1
cmp P3, P2
cmovl P1, P2
