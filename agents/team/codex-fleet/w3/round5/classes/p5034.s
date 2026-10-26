# n=5 model=out iset=I1 prefix14_class=5034
cmp P0, P1
mov S0, P3
mov S1, P1
cmovg P1, P0
cmovle S1, P0
cmp P3, P2
cmovle S0, P2
cmovle P2, P3
cmovge P3, P2
cmp S1, P3
cmovle P3, S1
cmovge P2, S1
cmp S0, P1
cmovle S2, S0
