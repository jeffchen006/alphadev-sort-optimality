# n=5 model=out iset=I1 prefix14_class=12444
cmp P3, P2
cmovle S2, P3
cmovl P3, P2
mov S1, P0
cmovl P2, S2
cmp P0, P1
cmovle S1, P1
cmovge P0, P1
cmp P0, P2
cmovl P1, P0
cmovle P0, P2
cmovl P2, P1
mov S0, P3
cmp S1, P3
