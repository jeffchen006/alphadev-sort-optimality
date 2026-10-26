# n=5 model=out iset=I1 prefix14_class=5345
mov S2, P1
cmp P2, P1
cmovl S2, P2
cmovge P1, P2
cmp P0, P3
cmovge S0, P3
cmovge P3, P0
cmovl S0, P0
cmp S0, S2
cmovle S1, S0
cmovl S0, S2
cmovle S2, S1
cmp P1, P3
mov S1, P1
