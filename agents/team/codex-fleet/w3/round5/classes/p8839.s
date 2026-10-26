# n=5 model=out iset=I1 prefix14_class=8839
cmp P1, P0
cmovle S2, P1
cmovg S2, P0
cmovle P1, P0
mov S1, P2
cmp P3, P2
cmovg P2, P3
cmovle S1, P3
cmp P2, P1
mov P0, P2
cmovg P0, P1
cmovge P1, P2
cmp S1, S2
cmovge S0, S1
