# n=5 model=out iset=I1 prefix14_class=1351
cmp P3, P0
mov S2, P1
cmovge S0, P0
cmovge P0, P3
mov S1, P0
cmovle S0, P3
cmp P2, S2
cmovl S2, P2
cmovg P1, P2
cmp P1, S1
cmovg P0, P1
cmovge P1, S1
cmp S0, S2
mov S1, P1
