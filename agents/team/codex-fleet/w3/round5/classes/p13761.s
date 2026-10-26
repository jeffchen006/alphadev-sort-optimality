# n=5 model=out iset=I1 prefix14_class=13761
mov S1, P0
cmp P0, P2
cmovl P0, P2
cmovge S1, P2
mov S0, P1
cmp S0, P3
cmovge P1, P3
cmovge P3, S0
cmp P3, P0
cmovl S2, P3
cmovle P3, P0
cmovl P0, S2
mov P3, P1
cmp S1, P3
