# n=5 model=out iset=I1 prefix14_class=513
mov S0, P2
cmp P3, P0
mov S2, P0
cmovge P0, P3
cmovle S2, P3
cmp S0, P1
cmovge S0, P1
cmovge P1, P2
mov P3, S2
cmp S0, S2
cmovl S2, S0
cmovle S0, P3
cmp P0, P1
cmovge S1, P0
