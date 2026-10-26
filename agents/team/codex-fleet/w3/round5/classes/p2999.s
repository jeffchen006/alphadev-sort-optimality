# n=5 model=out iset=I1 prefix14_class=2999
mov S0, P1
mov S2, P2
cmp S0, P0
cmovle S0, P0
cmovle P0, P1
mov S1, S0
cmp P2, P3
cmovge S2, P3
cmovg P3, P2
cmp S1, P3
cmovg S0, P3
cmovge P3, S1
cmp P0, S2
cmovge P1, P0
