# n=5 model=out iset=I1 prefix14_class=3763
mov S2, P2
mov S1, P1
cmp P0, S1
cmovge P1, P0
cmovle S1, P0
cmp P3, S2
cmovg S2, P3
mov S0, S1
cmovge P3, P2
cmp S1, P3
cmovle S1, P3
cmovle P3, S0
cmp P1, S2
cmovle P3, P1
