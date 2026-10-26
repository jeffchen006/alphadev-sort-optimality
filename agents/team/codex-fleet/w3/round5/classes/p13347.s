# n=5 model=out iset=I1 prefix14_class=13347
mov S1, P1
cmp S1, P2
cmovge S1, P2
mov S0, P0
mov S2, S1
cmovle P1, P2
cmp P0, P3
cmovle S0, P3
cmovle P3, P0
cmp S2, P3
cmovle S2, P3
cmovg S1, P3
cmp S0, P1
cmovg P0, P1
