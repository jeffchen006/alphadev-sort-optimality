# n=5 model=out iset=I1 prefix14_class=14252
cmp P1, P3
mov S0, P2
cmovg S1, P3
cmovg P3, P1
cmovg P1, S1
cmp P0, S0
cmovg S0, P0
cmovg P0, P2
cmp P3, S0
cmovg S2, P3
cmovle S2, S0
cmovg P3, S0
cmp P0, P1
cmovge S1, P0
