# n=5 model=out iset=I1 prefix14_class=2988
cmp P2, P0
cmovge S1, P2
cmovle S1, P0
cmovle P0, P2
cmp P3, P1
mov S2, P3
cmovge P3, P1
cmovge P1, S2
cmp S1, P1
cmovle S0, S1
cmovg S0, P1
cmovg P1, S1
cmp P0, P3
cmovge S2, P0
