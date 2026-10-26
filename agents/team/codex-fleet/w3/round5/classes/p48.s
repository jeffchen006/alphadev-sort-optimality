# n=5 model=out iset=I1 prefix14_class=48
mov S2, P1
mov S0, P2
cmp P0, P2
cmovle S0, P0
cmovl P0, P2
cmp P3, S2
cmovge P1, P3
mov S1, S0
cmovl S2, P3
cmp S1, S2
cmovl S0, S2
mov P2, P0
cmovge S1, S2
cmp P0, P1
