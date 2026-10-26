# n=5 model=out iset=I1 prefix14_class=10902
mov S2, P3
cmp P3, P1
cmovle P3, P1
cmovl P1, S2
cmp P2, P0
mov S1, P0
cmovle S1, P2
cmovge P0, P2
cmp P0, P3
cmovl S0, P0
cmovl P0, P3
cmovl P3, S0
cmp P1, S1
cmovle S0, S1
