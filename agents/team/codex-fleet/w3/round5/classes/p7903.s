# n=5 model=out iset=I1 prefix14_class=7903
mov S0, P3
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
cmovge S1, P1
cmp P2, P3
cmovge P3, P2
cmovle S0, P2
cmp S0, S1
mov S2, P0
cmovg P2, S0
cmovge S0, S1
cmovg S1, P2
cmp P0, P3
