# n=5 model=out iset=I1 prefix14_class=516
cmp P3, P0
mov S1, P3
cmovge S1, P0
cmovge P0, P3
mov S2, P2
cmp S2, P1
cmovg S2, P1
cmovge P1, P2
mov S0, P0
mov P2, S2
cmp S1, S2
cmovle S2, S1
cmovle S1, P2
cmovg P2, S1
