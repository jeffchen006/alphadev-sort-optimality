# n=5 model=out iset=I1 prefix14_class=4569
mov S0, P0
cmp P3, P0
cmovl S0, P3
cmovge P0, P3
cmp P2, P1
cmovge S2, P2
cmovge P2, P1
cmovle S2, P1
cmp P0, S2
mov S1, S2
cmovg S2, P0
cmovle S1, P0
mov S2, S1
cmp S0, P2
