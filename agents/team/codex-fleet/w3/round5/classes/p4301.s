# n=5 model=out iset=I1 prefix14_class=4301
mov S0, P0
cmp P0, P3
cmovg P0, P3
cmovle S0, P3
mov P3, P2
cmp P3, P1
cmovle P2, P1
cmovge P3, P1
mov S1, P3
cmp S1, P0
cmovle S1, P0
cmovl P0, P3
cmp P2, S0
cmovl P3, S0
