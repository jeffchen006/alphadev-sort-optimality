# n=5 model=out iset=I1 prefix14_class=14237
cmp P1, P3
cmovge S1, P1
cmovge P1, P3
cmovg P3, S1
mov S0, P2
cmp S0, P0
cmovl S0, P0
cmovl P0, P2
mov S2, P3
cmp P3, S0
cmovg S2, S0
cmovg S0, P3
cmp P1, P0
cmovle S0, P1
