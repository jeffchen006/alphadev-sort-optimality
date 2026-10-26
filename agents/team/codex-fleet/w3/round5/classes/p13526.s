# n=5 model=out iset=I1 prefix14_class=13526
cmp P3, P1
cmovle S1, P3
cmovg S1, P1
cmovle P3, P1
cmp P2, P0
cmovl S2, P2
cmovl P2, P0
mov S0, S1
cmovl P0, S2
cmp P0, S0
cmovle S0, P0
cmovge S1, P0
mov P0, P3
cmp P2, P3
