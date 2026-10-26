# n=5 model=out iset=I1 prefix14_class=7018
cmp P3, P0
mov S2, P2
mov S0, P0
cmovle S0, P3
cmovl P3, P0
cmp P2, P1
cmovle S2, P1
mov S1, S0
cmovge P2, P1
cmp S1, P2
cmovge S0, P2
cmovl S1, P2
cmp P3, S2
mov S0, S1
