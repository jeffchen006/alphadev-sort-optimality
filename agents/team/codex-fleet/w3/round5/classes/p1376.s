# n=5 model=out iset=I1 prefix14_class=1376
cmp P2, P3
mov S1, P1
cmovg S2, P3
cmovge P3, P2
cmovle S2, P2
cmp S1, P0
cmovg S1, P0
cmovge P0, P1
mov S0, P3
cmp P0, P3
cmovg S0, P0
cmovg P0, P3
mov P3, P0
cmp S1, S2
