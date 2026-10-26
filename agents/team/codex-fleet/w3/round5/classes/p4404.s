# n=5 model=out iset=I1 prefix14_class=4404
mov S2, P0
mov S1, P1
cmp P3, S2
cmovge P0, P3
cmovge P3, S2
cmp S1, P2
cmovge P1, P2
cmovle S1, P2
cmp P0, S1
cmovge S2, S1
cmovge S1, P0
mov S1, P3
cmovg P0, S2
cmp P3, P1
