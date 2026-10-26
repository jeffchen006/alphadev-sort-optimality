# n=5 model=out iset=I1 prefix14_class=12984
cmp P2, P0
mov S1, P2
cmovle S1, P0
cmovge P2, P0
mov S2, P3
cmp P1, S2
cmovle P3, P1
cmovle P1, S2
cmp P2, P3
cmovle S2, P3
cmovl P3, P2
cmovle P2, S2
mov S0, P1
cmp S1, S0
