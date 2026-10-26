# n=5 model=out iset=I1 prefix14_class=5141
cmp P2, P3
cmovle S0, P3
cmovle P3, P2
cmovge S0, P2
cmp P0, P1
cmovle P2, P1
cmovl P1, P0
cmovl P0, P2
mov S1, P3
cmp P3, P1
cmovge S1, P1
mov S1, S0
cmovg P1, P3
cmp P0, S1
