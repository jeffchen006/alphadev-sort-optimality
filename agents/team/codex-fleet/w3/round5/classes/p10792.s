# n=5 model=out iset=I1 prefix14_class=10792
mov S1, P2
cmp P0, S1
cmovge S1, P0
cmovl P2, P0
cmp P3, P1
mov S2, P3
cmovl P3, P1
cmovl P1, S2
cmp P3, S1
cmovle S0, P3
cmovle P3, S1
cmovle S1, S0
cmp P1, P2
cmovl P3, P2
