# n=5 model=out iset=I1 prefix14_class=11445
mov S2, P1
mov S1, P3
cmp P2, P1
cmovg S2, P2
cmovle P1, P2
cmp P0, P3
cmovg S1, P0
cmovge P0, P3
cmp P0, P1
mov P2, S2
cmovge P3, P1
cmovge P1, P0
cmovge P0, P3
cmp P2, S1
