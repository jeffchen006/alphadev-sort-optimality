# n=5 model=out iset=I1 prefix14_class=3369
cmp P3, P1
mov S0, P1
mov S2, P0
cmovle P1, P3
cmovge S0, P3
cmp P2, P0
cmovge P0, P2
cmovle S2, P2
cmp P1, S2
mov S1, P1
cmovg P1, S2
cmovge S2, S1
cmp P0, S0
mov S1, S0
