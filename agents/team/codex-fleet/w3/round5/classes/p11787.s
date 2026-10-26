# n=5 model=out iset=I1 prefix14_class=11787
cmp P2, P3
cmovg S2, P3
cmovge P3, P2
cmovg P2, S2
mov S1, P0
cmp P1, S1
cmovle S1, P1
cmovle P1, P0
cmp P3, P1
cmovg P0, P1
cmovle P0, P3
cmovle P3, P1
cmp S1, P2
cmovge S0, S1
