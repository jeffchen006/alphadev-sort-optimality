# n=5 model=out iset=I1 prefix14_class=5912
cmp P3, P2
cmovge S2, P3
mov S1, P1
cmovle S2, P2
cmovge P3, P2
cmp P0, S1
cmovg S1, P0
cmovge P0, P1
cmp S2, S1
cmovle S0, S2
cmovl S2, S1
cmovl S1, S0
mov S2, P0
cmp P0, P3
