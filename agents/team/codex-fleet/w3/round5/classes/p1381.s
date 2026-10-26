# n=5 model=out iset=I1 prefix14_class=1381
cmp P3, P2
mov S0, P0
cmovge S1, P2
cmovg P2, P3
cmovle S1, P3
cmp S0, P1
cmovge S0, P1
mov S2, P2
cmovge P1, P0
cmp P1, S2
cmovg S2, P1
mov S2, S1
cmovle P2, P1
cmp S2, S0
