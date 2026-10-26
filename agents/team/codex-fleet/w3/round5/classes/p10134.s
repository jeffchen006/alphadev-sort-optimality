# n=5 model=out iset=I1 prefix14_class=10134
cmp P2, P1
mov S2, P1
cmovle S2, P2
cmovle P2, P1
cmp P3, P0
cmovge P1, P3
cmovg P3, P0
cmovg P0, P1
mov S0, P3
mov S1, P2
cmp P2, P0
cmovle S1, P0
cmovle P0, P2
cmp S0, S2
