# n=5 model=out iset=I1 prefix14_class=4110
mov S2, P1
mov S1, P3
cmp P2, S1
cmovle P3, P2
cmovg S1, P2
cmp P0, S2
cmovge S2, P0
cmovge P0, P1
mov P1, P0
cmp P3, P1
cmovg P1, P3
cmovg P3, P0
cmp S1, S2
mov P3, S2
