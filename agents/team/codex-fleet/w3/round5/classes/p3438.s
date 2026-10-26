# n=5 model=out iset=I1 prefix14_class=3438
cmp P0, P3
cmovg S0, P3
mov S2, P2
cmovg P3, P0
cmovg P0, S0
cmp P2, P1
cmovg P2, P1
cmovle S2, P1
mov P1, P0
cmp P2, P1
cmovge P1, P2
cmovge P2, P0
cmp S2, P3
mov P0, P3
