# n=5 model=out iset=I1 prefix14_class=3670
mov S0, P2
cmp P0, S0
cmovle P2, P0
cmovge S0, P0
cmp P1, P3
cmovl P0, P1
cmovl P1, P3
cmovl P3, P0
cmp P2, P3
cmovle S1, P3
cmovl P3, P2
cmovl P2, S1
cmovg S1, P2
mov S2, S0
