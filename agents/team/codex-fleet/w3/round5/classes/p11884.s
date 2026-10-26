# n=5 model=out iset=I1 prefix14_class=11884
cmp P2, P3
cmovge S0, P3
mov S1, P1
cmovge P3, P2
cmovg P2, S0
cmp S1, P0
cmovle P1, P0
cmovg S1, P0
mov P0, P3
cmp P0, P1
cmovle P0, P1
cmovle P1, P3
cmp P2, S1
cmovle S0, P2
