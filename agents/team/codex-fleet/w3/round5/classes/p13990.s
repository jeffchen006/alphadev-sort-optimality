# n=5 model=out iset=I1 prefix14_class=13990
mov S2, P3
mov S1, P2
cmp S2, P0
cmovg S2, P0
cmovle P3, P0
cmp P1, S1
cmovle S1, P1
cmovge P2, P1
mov S0, P3
cmp S0, P2
cmovle S0, P2
cmovge P3, P2
mov S0, P3
cmp S1, S2
