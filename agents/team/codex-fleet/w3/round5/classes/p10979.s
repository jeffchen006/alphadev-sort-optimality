# n=5 model=out iset=I1 prefix14_class=10979
cmp P0, P2
cmovge S2, P0
cmovge P0, P2
cmovge P2, S2
cmp P3, P1
mov S0, P3
cmovl P3, P1
cmovl P1, S0
cmp P3, P2
cmovle S2, P3
cmovle P3, P2
cmovle P2, S2
cmp P0, P1
cmovle S2, P1
