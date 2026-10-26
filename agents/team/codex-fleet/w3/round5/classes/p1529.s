# n=5 model=out iset=I1 prefix14_class=1529
cmp P3, P1
mov S0, P3
cmovge S0, P1
cmovg P1, P3
cmp P2, P0
cmovle S1, P2
cmovge S1, P0
cmovg P0, P2
cmp S0, S1
cmovg S2, S0
cmovge S0, S1
cmovg S1, S2
cmp P0, P1
mov S0, P0
