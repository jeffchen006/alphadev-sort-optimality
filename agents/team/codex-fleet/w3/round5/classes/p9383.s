# n=5 model=out iset=I1 prefix14_class=9383
mov S1, P3
cmp P2, P1
mov S2, P1
cmovg P1, P2
cmovg P2, S2
cmp P3, P0
cmovle P3, P0
cmovle P0, S1
mov S0, P1
cmp P0, P2
cmovg S2, P0
cmovge P0, P2
cmovg P2, S2
cmp P1, P3
