# n=5 model=out iset=I1 prefix14_class=2997
mov S0, P1
mov S2, P2
cmp S0, P3
cmovle P1, P3
mov S1, P1
cmovle P3, S0
cmp P2, P0
cmovg S2, P0
cmovge P0, P2
cmp S1, P0
cmovg P1, P0
cmovge P0, S1
cmp S2, P3
cmovge S0, S2
