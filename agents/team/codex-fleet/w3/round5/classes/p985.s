# n=5 model=out iset=I1 prefix14_class=985
cmp P3, P1
mov S0, P0
mov S2, P3
cmovle S2, P1
cmovle P1, P3
cmp S0, P2
cmovg S0, P2
cmovge P2, P0
mov S1, P2
cmp S2, P2
cmovge P2, S2
cmovge S2, S1
cmp P1, S0
cmovge P0, S0
