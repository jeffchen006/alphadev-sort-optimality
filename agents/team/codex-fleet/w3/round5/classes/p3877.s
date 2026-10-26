# n=5 model=out iset=I1 prefix14_class=3877
mov S0, P2
mov S1, P0
cmp P0, P1
cmovge P0, P1
cmovg P1, S1
cmp S0, P3
mov S2, P0
cmovle S0, P3
cmovle P3, P2
cmp P0, P3
cmovle P0, P3
cmovl P3, S2
cmp P1, S0
cmovl P3, S0
