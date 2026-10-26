# n=5 model=out iset=I1 prefix14_class=1409
mov S2, P3
cmp P0, P3
cmovl S2, P0
mov S1, P1
cmovl P0, P3
cmp P2, S1
cmovl S1, P2
cmovge P1, P2
cmp P0, P1
cmovge S0, P1
cmovle S0, P0
cmovle P0, P1
cmovl P1, S0
mov P2, S1
