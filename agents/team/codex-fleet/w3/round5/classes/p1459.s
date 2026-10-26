# n=5 model=out iset=I1 prefix14_class=1459
mov S0, P0
cmp P0, P3
cmovge S0, P3
cmovg P3, P0
cmp P1, P2
mov S2, P1
cmovg P1, P2
cmovle S2, P2
cmp S2, P3
cmovge P0, P3
mov S1, P1
cmovg P3, S2
cmovg S2, P0
cmp S1, S0
