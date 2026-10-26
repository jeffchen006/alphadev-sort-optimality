# n=5 model=out iset=I1 prefix14_class=4226
cmp P0, P1
cmovge S1, P0
mov S0, P2
cmovle S1, P1
cmovg P0, P1
cmp P3, P2
cmovge S0, P3
cmovg P3, P2
cmp P3, P0
cmovl P1, P0
cmovl P0, P3
cmovge P1, P3
cmp S0, S1
cmovge S2, S0
