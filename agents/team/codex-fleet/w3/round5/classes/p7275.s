# n=5 model=out iset=I1 prefix14_class=7275
cmp P2, P3
cmovle S2, P3
mov S0, P0
cmovle P3, P2
cmovge S2, P2
cmp P1, P0
cmovle S0, P1
cmovle P1, P0
cmp S0, P3
cmovge P2, S0
cmovg S0, P3
cmovge P3, P2
cmp P1, S2
cmovle S0, P1
