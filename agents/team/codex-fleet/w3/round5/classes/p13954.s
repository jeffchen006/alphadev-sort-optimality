# n=5 model=out iset=I1 prefix14_class=13954
cmp P1, P3
cmovle S2, P1
cmovge S2, P3
cmovl P1, P3
cmp P2, P0
cmovge S1, P0
cmovle S1, P2
cmovg P0, P2
cmp P0, P1
cmovle S0, P1
cmovl P1, P0
cmovl P0, S0
cmp S2, S1
mov P0, S2
