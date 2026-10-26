# n=5 model=out iset=I1 prefix14_class=8013
mov S2, P1
cmp P3, S2
cmovg P1, P3
cmovg P3, S2
cmp P2, P0
cmovle S0, P0
cmovl P0, P2
cmovl P2, S0
cmp P3, P0
cmovge S1, P3
cmovle S1, P0
cmovl P0, P3
cmp P2, P1
cmovle S2, P2
