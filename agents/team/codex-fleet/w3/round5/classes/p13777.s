# n=5 model=out iset=I1 prefix14_class=13777
cmp P2, P3
cmovg S2, P2
cmovg P2, P3
mov S1, P1
cmovg P3, S2
cmp P1, P0
cmovge S1, P0
cmovg P0, P1
cmp P3, P0
cmovle P1, P3
cmovle P3, P0
mov S0, P2
cmovle P0, P1
cmp S1, S0
