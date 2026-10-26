# n=5 model=out iset=I1 prefix14_class=55
mov S2, P2
mov S1, P1
cmp P0, S2
cmovle P2, P0
cmovle P0, S2
cmp P3, S1
cmovle S1, P3
mov S2, P0
mov S0, P2
cmovge P1, P3
cmp P2, S1
cmovle S0, S1
cmovg P2, S1
mov S1, S0
