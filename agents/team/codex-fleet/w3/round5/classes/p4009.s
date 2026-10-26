# n=5 model=out iset=I1 prefix14_class=4009
cmp P1, P0
cmovle S0, P1
mov S2, P2
cmovg S0, P0
cmovle P1, P0
cmp S2, P3
cmovge S2, P3
cmovge P3, P2
cmp S0, S2
mov S1, S0
cmovge S1, S2
cmovg S2, S0
cmp P3, P1
cmovle P0, P3
