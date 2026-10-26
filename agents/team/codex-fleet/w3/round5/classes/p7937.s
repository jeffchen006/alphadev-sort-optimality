# n=5 model=out iset=I1 prefix14_class=7937
cmp P1, P3
cmovle S2, P3
cmovge S2, P1
cmovge P1, P3
mov S1, S2
mov S0, P0
cmp S0, P2
cmovg S0, P2
cmovg P2, P0
cmp P1, S0
cmovge P0, S0
cmovg S0, P1
cmovg P1, P0
cmp S2, P2
