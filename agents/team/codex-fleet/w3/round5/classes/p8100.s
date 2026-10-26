# n=5 model=out iset=I1 prefix14_class=8100
cmp P1, P0
mov S0, P2
cmovge S1, P0
cmovle S1, P1
cmovl P1, P0
mov S2, S1
cmp P3, S0
cmovg S0, P3
cmovge P3, P2
cmp P3, S2
cmovl S2, P3
cmovl S2, S0
cmovl P3, S1
cmp P1, S0
