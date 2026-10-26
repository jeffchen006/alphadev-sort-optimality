# n=5 model=out iset=I1 prefix14_class=1259
mov S2, P3
cmp P1, P3
cmovge S2, P1
cmovg P1, P3
cmp P2, P0
mov S0, S2
cmovle S1, P0
cmovg S1, P2
cmovle P0, P2
cmp S2, S1
cmovle S0, S1
cmovg S2, S1
cmp P1, P0
mov S0, P1
