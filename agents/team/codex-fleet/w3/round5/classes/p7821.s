# n=5 model=out iset=I1 prefix14_class=7821
cmp P2, P0
cmovge S2, P2
cmovg P2, P0
cmovge P0, S2
cmp P1, P3
cmovle S1, P1
cmovg S1, P3
mov S0, P2
cmovge P3, P1
cmp S0, S1
cmovg S0, S1
mov S0, P3
cmovle P2, S1
cmp P3, P0
