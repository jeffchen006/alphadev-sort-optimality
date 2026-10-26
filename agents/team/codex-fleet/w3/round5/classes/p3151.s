# n=5 model=out iset=I1 prefix14_class=3151
mov S0, P0
mov S1, P3
cmp P2, S1
cmovle S1, P2
cmovg P3, P2
cmp S0, P1
cmovge S0, P1
mov S2, S1
cmovge P1, P0
cmp S1, S0
cmovle S1, S0
cmovg S2, S0
cmp P1, P3
cmovg P2, P3
