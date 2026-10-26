# n=5 model=out iset=I1 prefix14_class=12803
mov S1, P2
mov S2, P1
cmp P0, P2
cmovle P2, P0
cmovg S1, P0
cmp P1, P3
cmovg P1, P3
cmovge P3, S2
cmp P1, P2
cmovge P0, P1
cmovg P1, P2
cmovg P2, P0
cmp P3, S1
cmovg P1, S1
