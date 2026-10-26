# n=5 model=out iset=I1 prefix14_class=5235
mov S0, P3
mov S1, P1
cmp P0, P1
cmovge S1, P0
cmovg P0, P1
cmp P2, S0
cmovle S0, P2
cmovle P2, P3
cmp S0, P0
cmovge P1, S0
mov S2, S1
cmovg S0, P0
cmovge P0, P1
cmp P2, S2
