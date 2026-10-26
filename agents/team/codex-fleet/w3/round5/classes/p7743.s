# n=5 model=out iset=I1 prefix14_class=7743
mov S1, P0
mov S2, P1
cmp P3, P0
cmovle P0, P3
cmovg S1, P3
cmp P2, S2
cmovg S2, P2
cmovg P2, P1
mov P1, P2
cmp P2, P0
cmovle P1, P0
cmovge P2, P0
cmp S2, S1
cmovge S0, S1
