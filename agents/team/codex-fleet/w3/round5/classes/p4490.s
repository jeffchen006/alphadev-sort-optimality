# n=5 model=out iset=I1 prefix14_class=4490
cmp P3, P2
mov S2, P2
cmovge S2, P3
cmovge P3, P2
cmp P0, P1
mov P2, P0
cmovle P0, P1
cmovge P2, P1
cmp P0, S2
cmovg P1, P0
cmovge P0, S2
cmovg S2, P1
cmp P3, P2
cmovge S2, P3
