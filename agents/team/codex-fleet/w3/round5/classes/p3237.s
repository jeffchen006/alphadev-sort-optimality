# n=5 model=out iset=I1 prefix14_class=3237
cmp P0, P1
cmovge S2, P0
cmovl S2, P1
cmovl P1, P0
mov S1, P2
cmp P3, S1
cmovle S1, P3
cmovg P2, P3
mov S0, P2
cmp P1, S1
cmovge P0, S1
cmovg S1, P1
cmovge P1, P0
cmp S2, P2
