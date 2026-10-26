# n=5 model=out iset=I1 prefix14_class=3120
cmp P3, P0
cmovge S1, P0
cmovge P0, P3
cmovle S1, P3
mov S0, P2
mov S2, S1
cmp P1, S0
cmovg P2, P1
cmovl S0, P1
cmp S1, S0
cmovge S1, S0
cmovle S2, S0
mov S0, P2
cmp P0, S0
