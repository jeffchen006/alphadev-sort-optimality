# n=5 model=out iset=I1 prefix14_class=4402
mov S2, P0
cmp P3, S2
cmovge P0, P3
cmovge P3, S2
cmp P1, P2
mov S1, P1
cmovg S1, P2
cmovle P1, P2
cmp P0, P1
cmovge S2, P1
cmovge P1, P0
cmovge P1, P3
cmovg P0, S2
cmp P3, S1
