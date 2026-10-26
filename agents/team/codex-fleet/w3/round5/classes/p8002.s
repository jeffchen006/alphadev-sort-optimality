# n=5 model=out iset=I1 prefix14_class=8002
cmp P1, P3
mov S0, P0
cmovge S2, P3
cmovge P3, P1
cmovge P1, S2
cmp S0, P2
cmovg S0, P2
cmovle P0, P2
cmp S0, P1
cmovg S1, S0
cmovle S1, P1
cmovle P1, S0
cmp P0, P3
cmovge P2, P3
