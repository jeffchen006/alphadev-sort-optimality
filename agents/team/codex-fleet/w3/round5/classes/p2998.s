# n=5 model=out iset=I1 prefix14_class=2998
mov S0, P1
mov S2, P2
cmp S0, P3
cmovle S0, P3
cmovle P3, P1
mov S1, S0
cmp P2, P0
cmovge S2, P0
cmovg P0, P2
cmp S1, P0
cmovg S0, P0
cmovge P0, S1
cmp P3, S2
cmovge P1, P3
