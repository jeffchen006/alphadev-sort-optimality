# n=5 model=out iset=I1 prefix14_class=10876
cmp P3, P2
cmovle S1, P2
mov S0, P1
cmovl P2, P3
cmovle P3, S1
cmp P0, P1
cmovl P1, P0
cmovle P0, S0
cmp P0, P3
mov S0, P0
cmovge S0, P3
cmovg P3, P0
cmp P2, P1
cmovl P0, P1
