# n=5 model=out iset=I1 prefix14_class=3640
mov S2, P0
cmp S2, P1
cmovl P0, P1
cmovl P1, S2
cmp P3, P2
mov S1, P1
mov S2, P2
cmovle P2, P3
cmovl P3, S2
cmp P2, S1
cmovge P1, P2
cmovle S1, P2
cmp P3, P0
cmovl P2, P3
