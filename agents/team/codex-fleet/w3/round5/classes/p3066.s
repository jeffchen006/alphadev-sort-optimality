# n=5 model=out iset=I1 prefix14_class=3066
cmp P0, P1
cmovge S1, P1
cmovge P1, P0
cmovg P0, S1
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmovg S1, P2
cmp S1, P0
mov P2, S1
mov S2, P3
cmovg S1, P0
cmovge P0, P2
mov S0, P0
