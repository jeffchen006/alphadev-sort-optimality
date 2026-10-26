# n=5 model=out iset=I1 prefix14_class=12926
cmp P2, P1
mov S0, P0
cmovge S2, P1
cmovg P1, P2
cmovg P2, S2
cmp P3, S0
cmovg S0, P3
cmovle P0, P3
cmp P2, P0
mov S1, P0
cmovg S1, P2
cmovle P0, P2
cmp S0, P1
mov P2, P1
