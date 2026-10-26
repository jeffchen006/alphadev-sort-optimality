# n=5 model=out iset=I1 prefix14_class=4809
mov S2, P3
cmp P1, P3
cmovle P3, P1
cmovge S2, P1
cmp P0, P2
cmovge P1, P0
cmovge P0, P2
cmovg P2, P1
mov S1, P0
cmp P3, P0
cmovle P0, P3
cmovge S1, P3
cmp S2, P2
cmovle P3, P2
