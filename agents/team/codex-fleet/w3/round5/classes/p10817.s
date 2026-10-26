# n=5 model=out iset=I1 prefix14_class=10817
mov S1, P3
cmp P2, S1
cmovle S1, P2
cmovge P3, P2
cmp P1, P0
mov S0, P1
cmovle S0, P0
cmovl P0, P1
cmp S0, P3
cmovl S2, S0
cmovl S0, P3
cmovl P3, S2
cmp P0, S1
cmovge S0, S1
