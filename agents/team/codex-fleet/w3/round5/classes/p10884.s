# n=5 model=out iset=I1 prefix14_class=10884
cmp P3, P0
cmovg S0, P0
cmovle S0, P3
cmovge P0, P3
cmp P1, P2
cmovge P3, P2
cmovg P2, P1
cmovge P1, P3
mov S1, P2
cmp P2, P0
cmovle S1, P0
cmovle P0, P2
cmp S0, P1
cmovle P2, P1
