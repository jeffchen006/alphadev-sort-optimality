# n=5 model=out iset=I1 prefix14_class=1555
mov S1, P2
cmp P0, P2
cmovge S1, P0
cmovge P0, P2
cmp P3, P1
mov P2, P3
cmovge P3, P1
cmovle P2, P1
mov S2, P0
cmp S2, P3
cmovge P0, P3
cmovg P3, S2
cmp S1, P2
cmovge S2, P2
