# n=5 model=out iset=I1 prefix14_class=10694
cmp P2, P3
cmovle S2, P3
cmovle P3, P2
cmovle P2, S2
cmp P1, P0
mov S0, P0
cmovle S0, P1
cmovl P1, P0
cmovge P0, P1
cmp P2, P0
cmovl P1, P2
cmovl P2, P0
mov S1, P3
cmp P3, S0
