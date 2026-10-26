# n=5 model=out iset=I1 prefix14_class=1210
cmp P0, P1
cmovle S0, P0
mov S2, P2
cmovl P0, P1
cmovl P1, S0
cmp P2, P3
cmovl S2, P3
mov S0, P0
cmovge P2, P3
cmp P0, S2
cmovge P0, S2
cmovge S2, S0
cmp P1, P2
cmovle S1, P1
