# n=5 model=out iset=I1 prefix14_class=2780
cmp P1, P2
cmovle S1, P2
mov S0, P0
cmovg S1, P1
cmovg P1, P2
cmp P3, S0
cmovg S0, P3
cmovge P3, P0
cmp S1, S0
cmovle S2, S1
cmovg S2, S0
cmovge S0, S1
cmp P1, P3
cmovge P2, P3
