# n=5 model=out iset=I1 prefix14_class=8953
cmp P1, P3
cmovle S1, P3
cmovge S1, P1
cmovge P1, P3
cmp P0, P2
cmovle S0, P0
cmovl P0, P2
cmovl P2, S0
cmp P0, S1
mov S2, P0
cmovge P0, S1
cmovl S2, S1
cmp P1, P2
mov S1, P1
