# n=5 model=out iset=I1 prefix14_class=10209
mov S1, P2
cmp P3, P2
mov S0, P1
cmovge S1, P3
cmovl P2, P3
cmp P0, S0
cmovge P1, P0
cmovl S0, P0
cmp P1, S1
cmovg S2, P1
cmovle S2, S1
cmovle S1, P1
cmp P2, S0
cmovle P0, S0
