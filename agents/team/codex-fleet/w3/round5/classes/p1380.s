# n=5 model=out iset=I1 prefix14_class=1380
cmp P3, P2
mov S0, P1
cmovge S2, P2
cmovle S2, P3
cmovg P2, P3
cmp P1, P0
cmovge S0, P0
mov S1, P2
cmovg P0, P1
cmp P0, S1
cmovg S1, P0
mov S1, S2
cmovle P2, P0
cmp S1, S0
