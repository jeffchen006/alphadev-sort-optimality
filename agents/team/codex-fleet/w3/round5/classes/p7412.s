# n=5 model=out iset=I1 prefix14_class=7412
cmp P0, P1
cmovge S1, P0
cmovg P0, P1
mov S2, P0
cmovle S1, P1
cmp P2, P3
cmovg S0, P3
cmovle S0, P2
cmovge P3, P2
cmp S2, S0
cmovg S2, S0
cmovle P0, S0
cmp S1, P3
cmovg S0, S1
