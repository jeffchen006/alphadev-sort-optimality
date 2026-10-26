# n=5 model=out iset=I1 prefix14_class=6943
cmp P3, P2
cmovle S1, P2
cmovg S1, P3
cmovg P3, P2
cmp P1, P0
cmovle S2, P1
cmovge S2, P0
cmovg P0, P1
cmp S1, P0
cmovge P2, S1
cmovge S1, P0
cmovg P0, P2
cmp P3, S2
cmovle P0, P3
