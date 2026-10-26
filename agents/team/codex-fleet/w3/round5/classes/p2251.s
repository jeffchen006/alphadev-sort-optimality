# n=5 model=out iset=I1 prefix14_class=2251
cmp P3, P1
cmovl S2, P1
mov S0, P2
cmovge S2, P3
cmovg P3, P1
cmp P0, P2
cmovge S0, P0
mov S1, S0
cmovge P0, P2
cmp S1, S2
cmovle S1, S2
mov S1, P3
cmovle S2, S0
cmp S1, P0
