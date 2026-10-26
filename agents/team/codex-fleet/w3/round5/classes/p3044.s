# n=5 model=out iset=I1 prefix14_class=3044
cmp P1, P2
cmovle S2, P2
cmovg S2, P1
cmovge P1, P2
mov S0, P3
cmp P0, S0
cmovle S0, P0
cmovle P0, P3
mov P3, P1
cmp S0, P3
cmovg P3, S0
cmovg S0, P1
cmp P0, S2
cmovle S1, S2
