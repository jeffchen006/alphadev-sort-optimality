# n=5 model=out iset=I1 prefix14_class=2385
mov S0, P3
cmp P3, P0
cmovg S0, P0
cmovg P0, P3
mov S2, P2
cmp P2, P1
mov S1, P0
cmovle S2, P1
cmovle P1, P2
cmp S1, S2
cmovle P0, S2
cmovle S2, S1
cmp P1, S0
cmovge P3, P1
