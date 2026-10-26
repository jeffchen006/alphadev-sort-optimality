# n=5 model=out iset=I1 prefix14_class=1366
mov S2, P2
cmp P0, S2
cmovge S2, P0
cmovle P2, P0
mov S1, P3
mov P0, S2
cmp S1, P1
cmovge S1, P1
cmovg P1, P3
cmp P1, P0
cmovge S2, P1
cmovg P1, P0
mov S2, P1
cmp P2, S1
