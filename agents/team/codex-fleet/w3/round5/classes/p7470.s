# n=5 model=out iset=I1 prefix14_class=7470
cmp P1, P0
mov S1, P2
mov S0, P1
cmovg S0, P0
cmovge P0, P1
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmp S0, S1
cmovle S2, S1
mov P2, P0
cmovle S1, S0
cmovle S0, S2
cmp P3, P2
