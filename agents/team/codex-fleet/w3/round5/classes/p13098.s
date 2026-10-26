# n=5 model=out iset=I1 prefix14_class=13098
mov S1, P1
cmp S1, P3
cmovle S1, P3
cmovge P1, P3
cmp P2, P0
mov P3, P0
cmovg P3, P2
cmovge P2, P0
cmp P2, P1
cmovg P0, P2
cmovge P2, P1
cmovg P1, P0
mov S2, P1
mov S0, P3
