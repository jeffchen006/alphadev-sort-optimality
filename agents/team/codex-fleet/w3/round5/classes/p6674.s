# n=5 model=out iset=I1 prefix14_class=6674
cmp P3, P1
cmovle S0, P1
cmovle P1, P3
mov S1, P2
cmovl P3, S0
cmp P0, S1
cmovle P2, P0
cmovle P0, S1
mov S0, P3
cmp P0, P3
cmovge S0, P0
cmovle P3, P0
cmp P1, P2
cmovle P0, P1
