# n=5 model=out iset=I1 prefix14_class=4157
mov S2, P3
cmp P0, P2
cmovle S0, P0
cmovge S0, P2
cmovge P2, P0
cmp S2, P1
cmovl P3, P1
cmovl P1, S2
cmp P1, S0
mov S2, S0
cmovge S0, P1
cmovl S2, P1
cmp P2, P3
cmovge P0, P2
