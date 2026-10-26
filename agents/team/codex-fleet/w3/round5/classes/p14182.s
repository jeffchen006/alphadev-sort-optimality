# n=5 model=out iset=I1 prefix14_class=14182
mov S1, P2
cmp P3, S1
cmovg S1, P3
cmovle P2, P3
mov S2, P1
cmp S2, P0
cmovg S2, P0
cmovle P1, P0
cmp P1, S1
cmovge P0, P1
cmovge P1, S1
cmovge S1, P0
cmp P2, S2
cmovg P0, S2
