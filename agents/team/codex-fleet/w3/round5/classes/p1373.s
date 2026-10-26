# n=5 model=out iset=I1 prefix14_class=1373
cmp P2, P3
cmovle S2, P2
mov S1, P1
cmovg S2, P3
cmovge P3, P2
cmp P1, P0
cmovge S1, P0
cmovg P0, P1
cmp P0, P3
mov S0, P3
cmovg S0, P0
cmovg P0, P3
cmp S2, S1
mov P2, P0
