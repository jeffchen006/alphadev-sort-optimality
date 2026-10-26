# n=5 model=out iset=I1 prefix14_class=5217
mov S1, P0
cmp S1, P1
cmovge P0, P1
cmovl S1, P1
cmp P2, P3
cmovle S0, P2
cmovl P2, P3
cmovge S0, P3
cmp S0, P0
cmovg S2, S0
cmovge S0, P0
cmovg P0, S2
cmp S1, P2
cmovge S0, P2
