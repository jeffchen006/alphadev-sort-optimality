# n=5 model=out iset=I1 prefix14_class=3323
cmp P0, P3
mov S2, P3
mov S0, P1
cmovge P3, P0
cmovl S2, P0
cmp S0, P2
cmovge P1, P2
cmovge P2, S0
cmp S2, P1
cmovle S1, S2
cmovge S1, P1
cmovl S2, P1
mov S0, S2
cmp P2, P3
