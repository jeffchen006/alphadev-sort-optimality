# n=5 model=out iset=I1 prefix14_class=5239
cmp P1, P2
cmovg S0, P1
mov S1, P3
cmovge P1, P2
cmovg P2, S0
cmp P0, S1
cmovle S1, P0
cmovle P0, P3
mov S2, S1
cmp S2, P1
cmovg S2, P1
cmovg P1, S1
mov S2, P2
cmp P0, S2
