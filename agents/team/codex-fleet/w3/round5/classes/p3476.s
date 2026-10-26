# n=5 model=out iset=I1 prefix14_class=3476
cmp P1, P3
cmovle S1, P3
cmovg S1, P1
mov S0, P2
cmovg P1, P3
cmp S0, P0
cmovle P2, P0
cmovle P0, S0
mov S0, P1
cmp P0, S0
cmovg S0, P0
cmovg P0, P1
cmp S1, P2
cmovge P0, S1
