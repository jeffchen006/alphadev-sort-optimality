# n=5 model=out iset=I1 prefix14_class=474
cmp P2, P0
cmovle S1, P0
cmovge S1, P2
cmovl P0, P2
mov S0, P3
cmp S0, P1
cmovge P3, P1
cmovge P1, S0
cmp P0, P3
cmovl S0, P3
cmovl P3, P0
cmovl P0, S0
mov P2, S1
cmp P2, P1
