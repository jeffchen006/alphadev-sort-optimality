# n=5 model=out iset=I1 prefix14_class=3989
mov S2, P0
cmp S2, P2
cmovle S2, P2
cmovge P0, P2
mov S1, P1
cmp S1, P3
cmovge S1, P3
cmovg P3, P1
mov P1, P0
cmp P0, S1
cmovg P0, S1
cmovg S1, P1
cmp P3, S2
cmovle S0, P3
