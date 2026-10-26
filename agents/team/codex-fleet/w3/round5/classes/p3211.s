# n=5 model=out iset=I1 prefix14_class=3211
cmp P1, P3
cmovle S1, P3
cmovg S1, P1
mov S0, P2
cmovl P3, P1
cmp P0, P2
cmovge P2, P0
cmovg P0, S0
cmovl S0, P0
cmp P3, P0
cmovg S0, P3
cmovg P3, P0
cmp S1, P2
cmovge S2, S1
