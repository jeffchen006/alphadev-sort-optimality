# n=5 model=out iset=I1 prefix14_class=7592
cmp P3, P0
mov S0, P0
cmovle P0, P3
cmovge S0, P3
cmp P1, P2
cmovl S1, P2
cmovle P2, P1
cmovl P1, S1
cmp P0, P2
cmovle S2, P0
cmovle P0, P2
cmovge S2, P2
mov S2, S0
cmp P1, S2
