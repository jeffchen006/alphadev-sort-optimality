# n=5 model=out iset=I1 prefix14_class=4214
cmp P2, P0
mov S1, P0
mov S2, P1
cmovle S1, P2
cmovge P0, P2
cmp P1, P3
cmovl P1, P3
cmovle P3, S2
cmp P3, S1
cmovge S0, S1
cmovl S0, P3
cmovge S1, P3
cmp P1, P0
cmovge S2, P1
