# n=5 model=out iset=I1 prefix14_class=13830
mov S2, P2
mov S1, P1
cmp S1, P3
cmovle S1, P3
cmovge P1, P3
cmp P0, S2
cmovg S2, P0
cmovle P2, P0
cmp S1, S2
cmovg P0, S2
cmovge S2, S1
cmovg S1, P0
cmp P2, P1
cmovle S2, P1
