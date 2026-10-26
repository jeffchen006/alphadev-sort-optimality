# n=5 model=out iset=I1 prefix14_class=7415
cmp P3, P1
cmovge S0, P1
cmovge P1, P3
mov S2, P0
cmovge P3, S0
cmp P2, P0
cmovle P0, P2
cmovg S2, P2
cmovge P2, P0
cmp P3, P2
cmovg P0, P3
cmovge P3, P2
cmp S2, P1
cmovg S0, P1
