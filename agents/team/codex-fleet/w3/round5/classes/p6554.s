# n=5 model=out iset=I1 prefix14_class=6554
cmp P0, P3
mov S1, P0
cmovle S1, P3
mov S2, S1
cmovge P0, P3
cmp P2, P1
cmovle S0, P2
cmovle P2, P1
cmovl P1, S0
cmp P2, S2
cmovle S2, P2
cmovge S1, P2
cmp P1, P0
mov S1, P1
