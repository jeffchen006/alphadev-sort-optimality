# n=5 model=out iset=I1 prefix14_class=490
cmp P3, P0
mov S0, P0
cmovle S0, P3
mov S1, P2
cmovge P0, P3
cmp P2, P1
cmovge S1, P1
cmovge P1, P2
cmp S0, S1
cmovl S2, S1
mov P2, P1
cmovle S1, S0
cmovl S0, S2
cmp P1, P0
