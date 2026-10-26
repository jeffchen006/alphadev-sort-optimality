# n=5 model=out iset=I1 prefix14_class=9202
mov S2, P0
mov S1, P1
cmp P3, P1
cmovge S1, P3
cmovge P3, P1
cmp P2, P0
cmovle S2, P2
cmovge P0, P2
mov S0, P3
cmp S2, P3
cmovge P3, S2
cmovg S2, S0
cmp S1, P0
cmovle P2, S1
