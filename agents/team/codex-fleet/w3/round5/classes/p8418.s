# n=5 model=out iset=I1 prefix14_class=8418
mov S1, P2
cmp P2, P1
cmovg S1, P1
cmovge P1, P2
cmp P3, P0
cmovg S2, P0
cmovle S2, P3
cmovg P0, P3
mov P3, S2
cmp P1, P0
cmovg S0, P0
cmovge P0, P1
cmovg P1, S0
cmp S1, S2
