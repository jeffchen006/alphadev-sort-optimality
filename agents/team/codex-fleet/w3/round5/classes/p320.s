# n=5 model=out iset=I1 prefix14_class=320
cmp P1, P2
mov S2, P3
cmovg S1, P1
cmovg P1, P2
cmovg P2, S1
cmp P0, S2
cmovge S2, P0
cmovle P3, P0
cmp P1, P3
cmovle P0, P1
cmovge P0, P3
cmovle P1, P3
mov S0, P1
cmp P2, S2
