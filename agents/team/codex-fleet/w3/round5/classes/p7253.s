# n=5 model=out iset=I1 prefix14_class=7253
cmp P2, P1
cmovle S1, P1
cmovle P1, P2
cmovge S1, P2
cmp P0, P3
mov S2, P3
cmovl P3, P0
mov S0, P3
cmovle P0, S2
cmp P3, P1
cmovle S0, P1
cmovg P3, P1
cmp S1, P0
cmovge P3, P0
