# n=5 model=out iset=I1 prefix14_class=10005
mov S0, P2
cmp P1, P2
cmovg S0, P1
cmovle P2, P1
mov S1, S0
cmp P3, P0
cmovle S2, P3
cmovg S2, P0
cmovge P0, P3
cmp S1, P0
cmovle S1, P0
mov S1, P2
cmovg S0, P0
mov P0, S0
