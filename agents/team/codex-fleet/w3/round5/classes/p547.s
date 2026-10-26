# n=5 model=out iset=I1 prefix14_class=547
mov S1, P1
mov S0, P0
cmp P0, P3
cmovg P0, P3
cmovg P3, S0
cmp P1, P2
cmovle P1, P2
cmovge S1, P2
mov S2, S1
cmp P0, S1
cmovle S1, P0
cmovge S2, P0
cmp P3, P1
cmovle S0, P1
