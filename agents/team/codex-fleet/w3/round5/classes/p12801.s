# n=5 model=out iset=I1 prefix14_class=12801
mov S1, P3
mov S2, P1
cmp P2, P3
cmovle P3, P2
cmovge S1, P2
cmp S2, P0
cmovg S2, P0
cmovg P0, P1
cmp S2, P3
cmovge P2, S2
cmovg S2, P3
cmovg P3, P2
cmp S1, P0
cmovle P2, S1
