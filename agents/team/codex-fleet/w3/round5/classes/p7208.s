# n=5 model=out iset=I1 prefix14_class=7208
mov S0, P3
mov S1, P0
cmp P3, P2
cmovl S0, P2
cmovge P3, P2
cmp P1, S1
cmovge P0, P1
cmovle S1, P1
mov S2, S1
cmp S1, P3
cmovl S1, P3
cmovge S2, P3
cmp S0, P0
cmovge S2, S0
