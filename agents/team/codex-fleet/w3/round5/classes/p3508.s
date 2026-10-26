# n=5 model=out iset=I1 prefix14_class=3508
mov S1, P3
mov S2, P2
cmp P1, S2
cmovge S2, P1
cmovg P1, P2
cmp P0, S1
cmovle S1, P0
cmovl P0, P3
mov P2, P1
cmp P2, S1
cmovl P2, S1
cmovle S1, P1
cmp P0, S2
cmovge S0, S2
