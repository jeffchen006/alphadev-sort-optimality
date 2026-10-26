# n=5 model=out iset=I1 prefix14_class=6772
mov S1, P1
mov S2, P3
cmp S1, P0
cmovle P1, P0
cmovge S1, P0
cmp P2, S2
cmovge P3, P2
cmovg P2, S2
cmp P3, P1
cmovg S2, P3
cmovge P3, P1
cmovg P1, S2
cmp P2, S1
cmovge P0, P2
