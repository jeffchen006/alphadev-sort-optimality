# n=5 model=out iset=I1 prefix14_class=6323
mov S0, P1
cmp P1, P3
cmovge S0, P3
cmovge P3, P1
cmp P0, P2
cmovle S1, P0
cmovle P0, P2
cmovle P2, S1
cmp P0, P3
cmovle P1, P0
cmovl P0, P3
cmovge P1, P3
cmp P2, S0
cmovg P0, S0
