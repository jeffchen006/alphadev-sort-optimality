# n=5 model=out iset=I1 prefix14_class=10095
cmp P1, P3
cmovg S1, P1
cmovle S1, P3
mov S0, P2
cmovle P3, P1
cmp S0, P0
cmovg P2, P0
cmovge P0, S0
cmp S1, P0
cmovle S0, S1
cmovle S1, P0
cmovle P0, S0
mov S2, P2
cmp P3, S2
