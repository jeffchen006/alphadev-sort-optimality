# n=5 model=out iset=I1 prefix14_class=14474
mov S0, P2
cmp P1, P3
cmovl S2, P3
cmovge S2, P1
cmovl P3, P1
cmp S0, P0
cmovge P2, P0
cmovl S0, P0
cmp P2, P3
cmovle S1, P3
cmovl P3, P2
cmovl P2, S1
cmp S2, S0
cmovge P1, S0
