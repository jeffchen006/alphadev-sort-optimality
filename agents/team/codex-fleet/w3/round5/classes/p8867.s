# n=5 model=out iset=I1 prefix14_class=8867
cmp P1, P0
mov S1, P1
mov S2, P2
cmovg P1, P0
cmovge P0, S1
cmp P3, P2
cmovg S2, P3
cmovg P3, P2
cmp P0, S2
mov S1, S2
cmovge S2, P0
cmovge P0, S1
cmp P3, P1
cmovle P2, P3
