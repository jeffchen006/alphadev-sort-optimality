# n=5 model=out iset=I1 prefix14_class=3248
mov S0, P0
cmp P2, S0
cmovge S0, P2
cmovge P2, P0
mov S1, P1
cmp P3, S1
cmovge S1, P3
cmovg P3, P1
mov S2, P2
cmp S2, P3
cmovg P2, P3
cmovle S2, P3
cmp S1, S0
cmovg P1, S0
