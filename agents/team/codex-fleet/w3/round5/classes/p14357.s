# n=5 model=out iset=I1 prefix14_class=14357
cmp P1, P3
cmovge S1, P1
cmovge P1, P3
cmovle S1, P3
cmp P0, P2
cmovle P3, P0
mov S0, P1
cmovle P0, P2
mov S2, S1
cmovl P2, P3
cmp P2, S0
cmovg P1, P2
cmovge P2, S0
cmp P0, S2
