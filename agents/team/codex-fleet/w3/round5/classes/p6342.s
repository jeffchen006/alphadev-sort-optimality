# n=5 model=out iset=I1 prefix14_class=6342
mov S2, P3
cmp S2, P1
cmovg S2, P1
cmovge P1, P3
cmp P2, P0
cmovge S0, P2
cmovl S0, P0
cmovl P0, P2
mov S1, S0
cmp S1, P1
cmovle S1, P1
cmovge S0, P1
cmp S2, P0
cmovg P1, S2
