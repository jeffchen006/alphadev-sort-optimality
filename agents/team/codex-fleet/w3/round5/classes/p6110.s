# n=5 model=out iset=I1 prefix14_class=6110
mov S1, P1
cmp S1, P3
cmovle S1, P3
cmovle P3, P1
cmp P2, P0
cmovge S0, P2
cmovge P2, P0
cmovg P0, S0
cmp P0, S1
cmovle S0, P0
cmovg S0, S1
cmovge S1, P0
cmp P2, P3
cmovle P0, P3
