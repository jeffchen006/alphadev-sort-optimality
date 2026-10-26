# n=5 model=out iset=I1 prefix14_class=3290
cmp P1, P3
cmovle S1, P3
cmovg S1, P1
cmovg P1, P3
mov P3, P1
cmp P2, P0
cmovge S0, P0
cmovg P0, P2
cmovge P2, S0
cmp P1, P2
cmovge P1, P2
mov S2, S1
cmovge P2, P3
mov P3, P2
