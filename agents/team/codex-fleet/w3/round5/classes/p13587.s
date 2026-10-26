# n=5 model=out iset=I1 prefix14_class=13587
cmp P0, P1
cmovge S0, P1
cmovge P1, P0
cmovl S0, P0
mov S1, P2
cmp P2, P3
cmovge S1, P3
cmovg P3, P2
cmp S1, S0
cmovge S2, S1
cmovle S2, S0
cmovl S0, S1
cmp P1, P3
cmovge P0, P1
