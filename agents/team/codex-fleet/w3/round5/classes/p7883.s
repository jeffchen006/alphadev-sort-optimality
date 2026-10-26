# n=5 model=out iset=I1 prefix14_class=7883
mov S2, P2
cmp S2, P3
cmovge S2, P3
cmovg P3, P2
mov P2, P1
cmp P2, P0
cmovle P1, P0
cmovge P2, P0
cmp S2, P2
mov P0, P1
cmovg S1, S2
cmovg S2, P2
cmovg P2, S1
cmp P1, P3
