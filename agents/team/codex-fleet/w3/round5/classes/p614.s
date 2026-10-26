# n=5 model=out iset=I1 prefix14_class=614
cmp P3, P2
mov S0, P0
cmovle S2, P2
cmovge S2, P3
cmovg P3, P2
cmp P0, P1
cmovge S0, P1
cmovg P1, P0
mov P0, S2
cmp P1, P0
cmovle P0, P1
cmovge S2, P1
cmp S0, P3
cmovge P2, P3
