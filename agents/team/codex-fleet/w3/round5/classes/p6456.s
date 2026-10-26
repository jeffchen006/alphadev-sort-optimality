# n=5 model=out iset=I1 prefix14_class=6456
cmp P0, P2
cmovl S1, P0
cmovl P0, P2
mov S0, P1
cmovl P2, S1
cmp S0, P3
cmovge P1, P3
cmovle S0, P3
cmp S0, P0
mov P3, S0
cmovge S0, P0
cmovge P0, P3
cmp P1, P2
cmovge S1, P2
