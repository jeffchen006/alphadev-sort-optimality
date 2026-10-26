# n=5 model=out iset=I1 prefix14_class=5989
cmp P0, P2
cmovle S1, P0
cmovl P0, P2
cmovl P2, S1
cmp P1, P3
cmovl S0, P3
cmovge S0, P1
cmovl P3, P1
cmp P0, S0
cmovle S2, P0
cmovg S2, S0
cmovl P0, S0
mov P0, P2
cmp P3, P0
