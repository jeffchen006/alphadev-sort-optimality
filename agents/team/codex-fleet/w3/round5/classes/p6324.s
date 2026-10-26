# n=5 model=out iset=I1 prefix14_class=6324
mov S1, P1
cmp P1, P3
cmovge S1, P3
cmovg P3, P1
cmp P0, P2
cmovle P1, P0
cmovle P0, P2
cmovle P2, P1
cmp P0, P3
cmovle S0, P0
cmovl P0, P3
cmovge S0, P3
cmp P2, S1
cmovg P0, S1
