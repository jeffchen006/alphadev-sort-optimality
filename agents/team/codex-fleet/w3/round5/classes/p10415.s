# n=5 model=out iset=I1 prefix14_class=10415
mov S0, P1
cmp P1, P0
cmovl S0, P0
cmovge P1, P0
cmp P2, P3
cmovge S2, P3
cmovg P3, P2
cmovle S2, P2
cmp S0, P3
cmovg P0, S0
cmovge S0, P3
cmovg P3, P0
cmp S2, P1
cmovge S1, P1
