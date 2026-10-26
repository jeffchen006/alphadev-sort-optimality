# n=5 model=out iset=I1 prefix14_class=1983
mov S1, P3
cmp P2, P0
cmovg S0, P2
cmovge P2, P0
cmovle S0, P0
cmp P1, S1
cmovge S1, P1
cmovl P3, P1
cmovl P1, S1
cmp P1, S0
cmovl S1, S0
cmovl S0, P1
cmp P2, P3
cmovle S1, P2
