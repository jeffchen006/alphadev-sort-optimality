# n=5 model=out iset=I1 prefix14_class=10352
cmp P2, P1
cmovg S0, P2
cmovle S0, P1
cmovg P2, P1
cmp P3, P0
cmovge P1, P0
cmovg P0, P3
cmovge P3, P1
mov S2, P0
cmp S0, P0
cmovle P0, S0
cmovge S2, S0
cmp P3, P2
cmovg S0, P3
