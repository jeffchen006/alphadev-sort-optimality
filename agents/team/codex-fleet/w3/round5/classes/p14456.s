# n=5 model=out iset=I1 prefix14_class=14456
cmp P1, P3
cmovg S2, P1
cmovg P1, P3
cmovg P3, S2
cmp P2, P0
mov S1, P2
cmovle P2, P0
mov S0, P3
cmovg S1, P0
cmp P1, S1
cmovg P0, P1
cmovge P1, S1
cmovg S1, P0
cmp S0, P2
