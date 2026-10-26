# n=5 model=out iset=I1 prefix14_class=1388
mov S0, P2
cmp P0, P1
cmovge S1, P1
cmovle S1, P0
cmovge P1, P0
cmovle P0, P1
cmp P2, P3
cmovge P2, P3
cmovge P3, S0
cmp P3, P0
cmovl P0, P3
cmovle P3, P1
cmovle P1, P0
mov S2, P2
