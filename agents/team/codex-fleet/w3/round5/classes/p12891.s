# n=5 model=out iset=I1 prefix14_class=12891
mov S0, P3
cmp P3, P0
cmovge P3, P0
cmovle S0, P0
cmp P2, P1
cmovle S2, P1
cmovle P1, P2
cmovle P2, S2
cmp P3, P1
cmovle S2, P3
cmovl P3, P1
cmovle P1, S2
cmp P2, S0
cmovl P0, P2
