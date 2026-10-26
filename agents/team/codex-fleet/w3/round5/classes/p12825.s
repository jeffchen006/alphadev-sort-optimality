# n=5 model=out iset=I1 prefix14_class=12825
mov S2, P3
mov S1, P2
cmp P0, S1
cmovge P2, P0
cmovle S1, P0
cmp S2, P1
cmovg S2, P1
mov P0, P2
cmovg P1, P3
cmp S1, S2
cmovge P3, S1
cmovge S1, S2
cmovge S2, P3
cmp P1, P2
