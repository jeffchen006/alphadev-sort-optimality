# n=5 model=out iset=I1 prefix14_class=2801
cmp P2, P3
cmovg S1, P2
cmovge P2, P3
cmovg P3, S1
cmp P1, P0
mov S2, P0
cmovle P0, P1
cmovle P1, S2
cmp P1, P3
cmovg S2, P3
mov S1, P0
cmovge P3, P1
cmovg P1, S2
mov P3, P1
