# n=5 model=out iset=I1 prefix14_class=10582
mov S2, P2
mov S0, P3
cmp P3, P0
cmovl P3, P0
cmovle P0, S0
cmp P1, S2
cmovge P2, P1
cmovle S2, P1
cmp P2, P3
mov S1, S2
cmovle S0, P2
cmovl P2, P3
cmovle P3, S0
cmp P0, S2
