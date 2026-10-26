# n=5 model=out iset=I1 prefix14_class=8409
mov S2, P3
mov S1, P0
cmp P3, P1
cmovge S2, P1
cmovg P1, P3
cmp P2, S1
cmovge S1, P2
cmovle P0, P2
cmp P1, S1
cmovge P2, S1
mov P3, P0
cmovg S1, P1
cmovg P1, P2
cmp S2, P0
