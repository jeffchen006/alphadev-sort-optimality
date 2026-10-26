# n=5 model=out iset=I1 prefix14_class=10256
cmp P0, P3
mov S1, P0
cmovge S1, P3
mov S0, P1
cmovle P0, P3
cmp P1, P2
cmovle S0, P2
cmovg P1, P2
cmp P0, S0
cmovle P2, P0
cmovle P0, S0
mov S2, S1
cmovle S0, P2
cmp P1, S1
