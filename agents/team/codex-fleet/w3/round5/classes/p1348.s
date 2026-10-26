# n=5 model=out iset=I1 prefix14_class=1348
cmp P3, P0
cmovge S0, P0
cmovle S0, P3
cmovge P0, P3
mov S2, P1
mov S1, P0
cmp P2, S2
cmovle S2, P2
cmovge P1, P2
cmp P1, S1
cmovg P0, P1
cmovge P1, S1
cmovl S1, P1
cmp S2, S0
