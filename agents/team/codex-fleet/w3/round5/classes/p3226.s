# n=5 model=out iset=I1 prefix14_class=3226
cmp P3, P1
mov S0, P2
cmovle S1, P3
cmovge S1, P1
cmovge P1, P3
cmp P0, S0
cmovle P2, P0
cmovg S0, P0
mov P3, P2
cmp S1, P2
cmovg P3, S1
cmovg S1, P2
cmp S0, P1
cmovle P0, P1
