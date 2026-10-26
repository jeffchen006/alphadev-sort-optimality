# n=5 model=out iset=I1 prefix14_class=12239
mov S2, P1
mov S0, P0
cmp P0, P3
cmovle P0, P3
cmovge S0, P3
cmp P2, P1
cmovge S2, P2
cmovl P1, P2
cmp P1, S0
cmovle P3, P1
cmovl P1, S0
cmovle S0, P3
cmp P0, S2
cmovle S1, P0
