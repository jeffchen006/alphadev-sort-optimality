# n=5 model=out iset=I1 prefix14_class=4585
cmp P1, P3
cmovle S2, P1
mov S1, P2
cmovl P1, P3
cmovle P3, S2
cmp P0, S1
cmovle S1, P0
cmovle P0, P2
mov S0, P0
cmp P1, S0
cmovg P0, P1
cmovle S0, P1
cmp P3, S1
cmovge P0, P3
