# n=5 model=out iset=I1 prefix14_class=7011
mov S2, P1
cmp P3, P0
cmovl S1, P0
cmovl P0, P3
cmovl P3, S1
cmp S2, P2
cmovle S2, P2
cmovl P2, P1
cmp P2, P0
cmovge S0, P2
cmovge P2, P0
cmovle S0, P0
mov P2, S2
cmp P3, S2
