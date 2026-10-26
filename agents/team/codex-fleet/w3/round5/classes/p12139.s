# n=5 model=out iset=I1 prefix14_class=12139
cmp P0, P3
cmovg S0, P3
cmovg P3, P0
mov S1, P2
cmovle S0, P0
cmp P1, P2
cmovge P2, P1
cmovge P1, S1
cmp S0, P1
cmovge S2, S0
cmovge S0, P1
mov P0, P2
cmovg P1, S2
mov S0, P1
