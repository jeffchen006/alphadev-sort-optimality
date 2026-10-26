# n=5 model=out iset=I1 prefix14_class=6723
cmp P3, P2
cmovg S1, P2
cmovge P2, P3
cmovg P3, S1
mov S1, P0
cmp S1, P1
cmovge S1, P1
cmovle P0, P1
cmp P2, P0
cmovg S0, P2
cmovge P2, P0
cmovg P0, S0
cmp S1, P3
cmovg S2, S1
