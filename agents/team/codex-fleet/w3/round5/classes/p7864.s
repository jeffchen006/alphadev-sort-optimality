# n=5 model=out iset=I1 prefix14_class=7864
mov S0, P2
mov S1, P0
cmp P1, S0
cmovle S0, P1
cmovge P2, P1
cmp P3, P0
cmovle P0, P3
mov S2, P0
cmovg S1, P3
cmp S0, S2
cmovg S2, S0
cmovle P0, S0
cmp P2, S1
cmovle P3, P2
