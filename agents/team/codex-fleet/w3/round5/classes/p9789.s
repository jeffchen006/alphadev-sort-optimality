# n=5 model=out iset=I1 prefix14_class=9789
cmp P3, P2
cmovge S0, P2
cmovge P2, P3
mov S2, P1
cmovge P3, S0
cmp P1, P0
cmovg S2, P0
mov S1, P2
cmovle P1, P0
cmp P1, S1
mov P0, P3
cmovle S1, P1
cmovg P2, P1
cmovge P1, S1
