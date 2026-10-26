# n=5 model=out iset=I1 prefix14_class=555
cmp P1, P3
cmovge S0, P1
cmovg P1, P3
mov S2, P2
cmovge P3, S0
mov S1, P3
cmp S2, P0
cmovge P2, P0
cmovle S2, P0
cmp P2, P1
cmovle P0, P1
cmovle P1, P2
cmovg P0, P2
cmp S2, P3
