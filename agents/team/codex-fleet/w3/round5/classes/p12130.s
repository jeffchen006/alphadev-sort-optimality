# n=5 model=out iset=I1 prefix14_class=12130
cmp P3, P1
cmovle S0, P3
mov S1, P2
cmovg S0, P1
cmovg P1, P3
cmp P0, P2
cmovle S1, P0
cmovge P2, P0
cmp S1, S0
cmovg P0, S0
cmovge S0, S1
cmovg S1, P0
mov S2, P1
cmp P1, P2
