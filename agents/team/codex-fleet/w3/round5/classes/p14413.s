# n=5 model=out iset=I1 prefix14_class=14413
mov S1, P0
cmp P2, P0
cmovle S1, P2
mov S0, P1
cmovge P0, P2
cmp P3, S0
cmovg P1, P3
cmovge P3, S0
cmp S1, P3
cmovge S0, S1
cmovg S1, P3
cmovg P3, S0
cmp P1, P0
cmovge S2, P1
