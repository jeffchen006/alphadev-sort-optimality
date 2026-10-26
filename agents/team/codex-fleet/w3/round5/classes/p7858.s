# n=5 model=out iset=I1 prefix14_class=7858
mov S1, P3
cmp P0, S1
cmovge S1, P0
cmovle P3, P0
cmp P2, P1
cmovl P0, P2
cmovge P0, P1
cmovg P1, P2
cmp P0, P3
cmovle S0, P0
cmovle P0, P3
cmovl P3, S0
cmp S1, P1
cmovle P3, S1
