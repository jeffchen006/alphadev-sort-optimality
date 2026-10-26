# n=5 model=out iset=I1 prefix14_class=11499
mov S2, P3
cmp S2, P0
mov S1, P2
cmovle P3, P0
cmovl P0, S2
cmp S1, P1
cmovge P2, P1
cmovle S1, P1
cmp P0, P2
cmovle P1, P0
cmovl P0, P2
cmovl P2, P1
cmp S1, P3
mov S0, S1
