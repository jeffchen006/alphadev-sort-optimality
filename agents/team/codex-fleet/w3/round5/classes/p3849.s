# n=5 model=out iset=I1 prefix14_class=3849
mov S1, P3
cmp S1, P2
cmovge P3, P2
cmovg P2, S1
cmp P1, P0
cmovge S0, P1
cmovle S0, P0
cmovle P0, P1
mov S1, P3
cmp P3, P0
cmovle P3, P0
cmovle P0, S1
cmp P2, S0
cmovg P0, S0
