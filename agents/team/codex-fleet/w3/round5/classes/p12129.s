# n=5 model=out iset=I1 prefix14_class=12129
cmp P3, P1
cmovg S0, P1
cmovle S0, P3
mov S1, P0
cmovg P1, P3
cmp P2, P0
cmovle S1, P2
cmovge P0, P2
cmp S1, S0
cmovg P2, S0
cmovge S0, S1
cmovg S1, P2
cmp P0, P1
mov S2, P0
