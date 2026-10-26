# n=5 model=out iset=I1 prefix14_class=5927
cmp P1, P0
cmovl S2, P0
mov S0, P2
cmovge S2, P1
cmovge P1, P0
cmp P3, P2
cmovl P2, P3
cmovge S0, P3
mov P0, S0
cmp S2, P0
cmovle S0, S2
cmovl S2, P0
cmovle P0, S0
mov S2, P1
