# n=5 model=out iset=I1 prefix14_class=12465
mov S2, P2
cmp P2, P1
cmovle P2, P1
mov S0, P3
cmovg S2, P1
cmp S0, P0
mov S1, S2
cmovg S0, P0
cmovge P0, P3
cmp S0, S2
cmovge S2, S0
cmovg S0, S1
cmp P2, P0
cmovle S1, S2
