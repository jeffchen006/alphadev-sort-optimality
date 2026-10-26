# n=5 model=out iset=I1 prefix14_class=10414
mov S0, P1
cmp P1, P0
cmovle S0, P0
cmovge P1, P0
cmp P2, P3
cmovge S2, P3
cmovg P3, P2
cmovle S2, P2
cmp S0, P3
cmovg S1, S0
cmovge S0, P3
cmovg P3, S1
cmp S2, P1
cmovge P0, P1
