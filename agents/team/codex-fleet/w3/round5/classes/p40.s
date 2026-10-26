# n=5 model=out iset=I1 prefix14_class=40
cmp P3, P0
mov S0, P2
mov S1, P0
cmovle P0, P3
cmovle P3, S1
cmp P1, S0
cmovge P2, P1
mov S1, P0
mov S2, P2
cmovle S0, P1
cmp P0, S0
cmovle S1, S0
cmovg P0, S0
cmp P2, P3
