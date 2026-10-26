# n=5 model=out iset=I1 prefix14_class=7199
cmp P1, P3
cmovg S2, P3
cmovge P3, P1
mov S1, P2
cmovg P1, S2
cmp S1, P0
cmovg S1, P0
cmovge P0, P2
cmp S1, P1
cmovge S0, P1
cmovle S0, S1
cmovl S1, P1
cmovg P1, S1
cmp P3, P0
